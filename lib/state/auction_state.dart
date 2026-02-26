import 'package:get/get.dart';
import '../models/auction_model.dart';
import '../core/constants/app_constants.dart';
import '../core/api/api_client.dart' as api;
import '../services/auction_service.dart';
import 'auth_state.dart';

/// Auction state controller
/// Manages auction list, bids, and auction lifecycle
class AuctionState extends GetxController {
  // Observable state
  final _auctions = <AuctionModel>[].obs;
  final _myBids = <AuctionModel>[].obs; // User's bidded auctions from API
  final _isLoading = false.obs;
  final _isLoadingMyBids = false.obs;
  final _selectedAuction = Rxn<AuctionModel>();
  final AuctionService _auctionService = AuctionService();
  bool _hasLoadedAuctions = false;
  bool _hasLoadedMyBids = false;
  bool _isLoadingInProgress = false;
  bool _isLoadingMyBidsInProgress = false;
  bool _isFirstLoad = true;

  @override
  void onInit() {
    print('AuctionState: onInit called');
    super.onInit();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      loadAuctions();
    }
  }

  // Getters - return observable list directly for GetX tracking
  RxList<AuctionModel> get auctions => _auctions;
  RxList<AuctionModel> get myBids => _myBids; // User's bidded auctions from API
  bool get isLoading => _isLoading.value;
  bool get isLoadingMyBids => _isLoadingMyBids.value;
  AuctionModel? get selectedAuction => _selectedAuction.value;

  List<AuctionModel> get liveAuctions =>
      _auctions.where((a) => a.isLive && !a.isPendingApproval).toList();
  // _auctions.where((a) => !a.isClosed).toList(); // Show all non-closed auctions (live + pending)

  List<AuctionModel> get closedAuctions =>
      _auctions.where((a) => a.isClosed).toList();

  List<AuctionModel> get pendingApprovalAuctions =>
      _auctions.where((a) => a.isPendingApproval).toList();

  /// Get auctions where the current user has placed bids (live auctions)
  /// DEPRECATED: Use myBids from API instead
  List<AuctionModel> getBiddedAuctions(String userId) {
    // Return API data if available, otherwise fallback to filtering
    if (_myBids.isNotEmpty) {
      return _myBids.toList();
    }
    return _auctions.where((auction) {
      if (!auction.isLive || auction.isPendingApproval) return false;
      return auction.bids.any((bid) => bid.userId == userId);
    }).toList();
  }

  /// Get closed auctions where user bid but was outbid
  List<AuctionModel> getClosedOutbidAuctions(String userId) {
    return _auctions.where((auction) {
      if (!auction.isClosed) return false;
      // User has bid on this auction
      final hasUserBid = auction.bids.any((bid) => bid.userId == userId);
      if (!hasUserBid) return false;
      // User is not the current winner
      return auction.currentBidderId != userId;
    }).toList();
  }

  /// Load auctions from API
  ///
  /// [forceRefresh] - If true, will reload even if data already exists
  Future<void> loadAuctions({bool forceRefresh = false}) async {
    // If already loaded and not forcing refresh, skip
    if (_hasLoadedAuctions && !forceRefresh) {
      print(
        'AuctionState: Auctions already loaded (${_auctions.length} items), skipping...',
      );
      return;
    }

    // Clear any dummy/old data if forcing refresh
    if (forceRefresh) {
      print('AuctionState: Force refresh - clearing existing data');
      _auctions.clear();
    }

    if (_isLoadingInProgress) {
      print('AuctionState: Already loading, skipping duplicate request');
      return;
    }

    _isLoadingInProgress = true;
    _isLoading.value = true;

    try {
      print('AuctionState: Fetching auctions from API...');
      final response = await _auctionService.getAuctions();
      print('AuctionState: RAW RESPONSE: $response');

      final auctionsData = response['data'] as List<dynamic>? ?? [];
      print(
        'AuctionState: Received ${auctionsData.length} auctions from data field',
      );
      if (auctionsData.isNotEmpty) {
        print('AuctionState: First Auction Raw Data: ${auctionsData.first}');
      }

      // Parse each auction from JSON
      final auctions = auctionsData
          .map((json) => AuctionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _auctions.value = auctions;
      _hasLoadedAuctions = true;
      print('AuctionState: Parsed ${auctions.length} auctions');
    } on api.ApiException catch (e) {
      print('AuctionState: API error - ${e.message}');
      // Don't show snackbar here - let the UI handle it
    } catch (e) {
      print('AuctionState: Unexpected error - $e');
    } finally {
      _isLoading.value = false;
      _isLoadingInProgress = false;
    }
  }

  /// Load user's bidded auctions from API
  ///
  /// [forceRefresh] - If true, will reload even if data already exists
  Future<void> loadMyBids({bool forceRefresh = false}) async {
    // Check if user is authenticated
    final authState = Get.find<AuthState>();
    if (!authState.isAuthenticated) {
      print('AuctionState.loadMyBids: User not authenticated, skipping...');
      _myBids.clear();
      return;
    }

    // If already loaded and not forcing refresh, skip
    if (_hasLoadedMyBids && !forceRefresh) {
      print(
        'AuctionState.loadMyBids: My bids already loaded (${_myBids.length} items), skipping...',
      );
      return;
    }

    // Clear any dummy/old data if forcing refresh
    if (forceRefresh) {
      print('AuctionState.loadMyBids: Force refresh - clearing existing data');
      _myBids.clear();
      _hasLoadedMyBids = false; // Reset flag on force refresh
    }

    if (_isLoadingMyBidsInProgress) {
      print(
        'AuctionState.loadMyBids: Already loading, skipping duplicate request',
      );
      return;
    }

    _isLoadingMyBidsInProgress = true;
    _isLoadingMyBids.value = true;

    try {
      // Ensure token is set in ApiClient
      final token = authState.currentUser?.token;
      if (token != null && token.isNotEmpty) {
        final apiClient = api.ApiClient();
        if (apiClient.token != token) {
          apiClient.setToken(token);
          print('AuctionState.loadMyBids: Set token in ApiClient');
        }
      }

      print('AuctionState.loadMyBids: Fetching my bids from API...');
      final response = await _auctionService.getMyBids();

      final bidsData = response['data'] as List<dynamic>;
      print(
        'AuctionState.loadMyBids: Received ${bidsData.length} bidded auctions',
      );

      // Parse each auction from JSON
      final auctions = bidsData
          .map((json) => AuctionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _myBids.value = auctions;
      _hasLoadedMyBids = true;
      _isLoadingMyBids.value = false;
      _isLoadingMyBidsInProgress = false;
      update();

      print(
        'AuctionState.loadMyBids: Successfully loaded ${auctions.length} bidded auctions',
      );
    } catch (e) {
      print('AuctionState.loadMyBids: Error loading my bids - $e');
      _isLoadingMyBids.value = false;
      _isLoadingMyBidsInProgress = false;
      // Clear my bids on error
      _myBids.clear();
    }
  }

  // Mock data initialization removed - use loadAuctions() instead
  // Keeping this commented for reference if needed for testing
  /*
  void _initializeMockData() {
    final now = DateTime.now();
    
    _auctions.value = [
      // Live auction
      AuctionModel(
        id: 'auction_1',
        title: '2020 BMW 3 Series',
        description: 'Well-maintained BMW 3 Series with low mileage',
        carMake: 'BMW',
        carModel: '3 Series',
        carYear: 2020,
        startingBid: 50000.0,
        currentBid: 52000.0,
        currentBidderId: 'user_1',
        status: AuctionStatus.live,
        startTime: now.subtract(const Duration(hours: 24)),
        endTime: now.add(const Duration(hours: 48)),
        createdAt: now.subtract(const Duration(days: 1)),
        bids: [
          BidModel(
            id: 'bid_1',
            auctionId: 'auction_1',
            userId: 'user_1',
            userName: 'John Doe',
            amount: 52000.0,
            timestamp: now.subtract(const Duration(hours: 2)),
            isWinning: true,
          ),
        ],
      ),
      // Another live auction (with user bid)
      AuctionModel(
        id: 'auction_2',
        title: '2019 Mercedes C-Class',
        description: 'Luxury sedan in excellent condition',
        carMake: 'Mercedes',
        carModel: 'C-Class',
        carYear: 2019,
        startingBid: 60000.0,
        currentBid: 62000.0,
        currentBidderId: 'user_1',
        status: AuctionStatus.live,
        startTime: now.subtract(const Duration(hours: 12)),
        endTime: now.add(const Duration(hours: 60)),
        createdAt: now.subtract(const Duration(hours: 12)),
        bids: [
          BidModel(
            id: 'bid_2',
            auctionId: 'auction_2',
            userId: 'user_1',
            userName: 'John Doe',
            amount: 62000.0,
            timestamp: now.subtract(const Duration(hours: 1)),
            isWinning: true,
          ),
        ],
      ),
      // Another live auction
      AuctionModel(
        id: 'auction_5',
        title: '2022 Tesla Model 3',
        description: 'Electric vehicle with autopilot',
        carMake: 'Tesla',
        carModel: 'Model 3',
        carYear: 2022,
        startingBid: 80000.0,
        currentBid: 82000.0,
        currentBidderId: 'user_3',
        status: AuctionStatus.live,
        startTime: now.subtract(const Duration(hours: 6)),
        endTime: now.add(const Duration(hours: 66)),
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      // Pending approval
      AuctionModel(
        id: 'auction_3',
        title: '2021 Audi A4',
        description: 'Premium sedan with advanced features',
        carMake: 'Audi',
        carModel: 'A4',
        carYear: 2021,
        startingBid: 55000.0,
        status: AuctionStatus.pendingApproval,
        startTime: now.add(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      // Closed auction (user was outbid)
      AuctionModel(
        id: 'auction_4',
        title: '2018 Toyota Camry',
        description: 'Reliable family sedan',
        carMake: 'Toyota',
        carModel: 'Camry',
        carYear: 2018,
        startingBid: 30000.0,
        currentBid: 32000.0,
        currentBidderId: 'user_2', // User 1 was outbid
        status: AuctionStatus.closed,
        startTime: now.subtract(const Duration(days: 5)),
        endTime: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 5)),
        bids: [
          BidModel(
            id: 'bid_4',
            auctionId: 'auction_4',
            userId: 'user_1', // User 1 bid but was outbid
            userName: 'John Doe',
            amount: 31000.0,
            timestamp: now.subtract(const Duration(days: 4)),
            isWinning: false,
          ),
          BidModel(
            id: 'bid_5',
            auctionId: 'auction_4',
            userId: 'user_2',
            userName: 'Jane Smith',
            amount: 32000.0,
            timestamp: now.subtract(const Duration(days: 3)),
            isWinning: true,
          ),
        ],
      ),
    ];
  }
  */

  /// Select an auction (or clear selection if auctionId is empty)
  void selectAuction(String auctionId) {
    if (auctionId.isEmpty) {
      _selectedAuction.value = null;
      return;
    }
    _selectedAuction.value = _auctions.firstWhereOrNull(
      (a) => a.id == auctionId,
    );
  }

  /// Load single auction details from API
  ///
  /// Updates the selected auction with detailed information including bids
  Future<AuctionModel?> loadAuctionDetails(String auctionId) async {
    if (_isLoadingInProgress) {
      print('AuctionState: Already loading, skipping duplicate request');
      return _selectedAuction.value;
    }

    _isLoadingInProgress = true;
    _isLoading.value = true;

    try {
      print('AuctionState: Fetching auction details for ID: $auctionId');
      final auctionData = await _auctionService.getAuction(auctionId);
      print('AuctionState: Received auction details');

      // Parse auction from JSON (this will include bids if present)
      final auction = AuctionModel.fromJson(auctionData);

      // Update or add to auctions list
      final existingIndex = _auctions.indexWhere((a) => a.id == auctionId);
      if (existingIndex >= 0) {
        _auctions[existingIndex] = auction;
      } else {
        _auctions.add(auction);
      }

      // Set as selected auction
      _selectedAuction.value = auction;
      print('AuctionState: Auction details loaded successfully');

      return auction;
    } on api.ApiException catch (e) {
      print('AuctionState: API error loading auction details - ${e.message}');
      _selectedAuction.value = null;
      return null;
    } catch (e) {
      print('AuctionState: Unexpected error loading auction details - $e');
      _selectedAuction.value = null;
      return null;
    } finally {
      _isLoading.value = false;
      _isLoadingInProgress = false;
    }
  }

  /// Place a bid on an auction using the API
  ///
  /// Returns true if successful, false otherwise
  Future<bool> placeBid(String auctionId, double amount) async {
    print('AuctionState.placeBid: ==========================================');
    print('AuctionState.placeBid: START - placeBid called');
    print('AuctionState.placeBid: Auction ID: $auctionId');
    print('AuctionState.placeBid: Amount: $amount');
    print('AuctionState.placeBid: ==========================================');

    // Check if user is authenticated
    final authState = Get.find<AuthState>();
    final token = authState.currentUser?.token;

    print('AuctionState.placeBid: Checking authentication...');
    print('AuctionState.placeBid: Token exists: ${token != null}');
    print(
      'AuctionState.placeBid: Token value: ${token != null ? (token.length > 20 ? "${token.substring(0, 20)}..." : token) : "null"}',
    );

    if (token == null || token.isEmpty) {
      print('AuctionState.placeBid: ERROR - Cannot place bid - no token');
      print('AuctionState.placeBid: Returning false');
      return false;
    }

    // Ensure token is set in ApiClient (it's a singleton)
    final apiClient = api.ApiClient();
    if (apiClient.token != token) {
      apiClient.setToken(token);
      print('AuctionState.placeBid: Set token in ApiClient');
    }

    // Validate auction exists and is live
    print('AuctionState.placeBid: Validating auction...');
    print('AuctionState.placeBid: Total auctions in list: ${_auctions.length}');
    final auctionIndex = _auctions.indexWhere((a) => a.id == auctionId);
    print('AuctionState.placeBid: Auction index: $auctionIndex');

    if (auctionIndex == -1) {
      print('AuctionState.placeBid: ERROR - Auction not found - $auctionId');
      print(
        'AuctionState.placeBid: Available auction IDs: ${_auctions.map((a) => a.id).toList()}',
      );
      return false;
    }

    final auction = _auctions[auctionIndex];
    print('AuctionState.placeBid: Auction found: ${auction.title}');
    print('AuctionState.placeBid: Auction isLive: ${auction.isLive}');
    print('AuctionState.placeBid: Auction status: ${auction.status}');

    if (!auction.isLive) {
      print('AuctionState.placeBid: ERROR - Auction is not live - $auctionId');
      return false;
    }

    // Validate minimum bid
    final minBid =
        (auction.currentBid ?? auction.startingBid) +
        AppConstants.minBidIncrement;
    print('AuctionState.placeBid: Current bid: ${auction.currentBid}');
    print('AuctionState.placeBid: Starting bid: ${auction.startingBid}');
    print('AuctionState.placeBid: Minimum bid required: $minBid');
    print('AuctionState.placeBid: Bid amount provided: $amount');

    if (amount < minBid) {
      print(
        'AuctionState.placeBid: ERROR - Bid amount $amount is less than minimum $minBid',
      );
      return false;
    }

    print(
      'AuctionState.placeBid: All validations passed! Proceeding to API call...',
    );

    _isLoading.value = true;

    try {
      print(
        'AuctionState.placeBid: Placing bid of $amount on auction $auctionId',
      );
      final response = await _auctionService.placeBid(auctionId, amount);
      print('AuctionState.placeBid: Bid placed successfully - $response');

      // Reload auction details to get updated bid information
      await loadAuctionDetails(auctionId);

      // Also refresh the auctions list to show updated current bid
      await loadAuctions(forceRefresh: true);

      // Refresh my bids to include the newly placed bid
      await loadMyBids(forceRefresh: true);

      _isLoading.value = false;
      return true;
    } on api.ApiException catch (e) {
      print('AuctionState.placeBid: API error - ${e.message}');
      _isLoading.value = false;
      // Re-throw to let the controller handle the error message
      rethrow;
    } catch (e) {
      print('AuctionState.placeBid: Unexpected error - $e');
      _isLoading.value = false;
      return false;
    }
  }

  /// Approve auction (admin)
  Future<void> approveAuction(String auctionId) async {
    _isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    final auctionIndex = _auctions.indexWhere((a) => a.id == auctionId);
    if (auctionIndex != -1) {
      _auctions[auctionIndex] = _auctions[auctionIndex].copyWith(
        status: AuctionStatus.approved,
      );
    }

    _isLoading.value = false;
    update();
  }

  /// Reject auction (admin)
  Future<void> rejectAuction(String auctionId) async {
    _isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    final auctionIndex = _auctions.indexWhere((a) => a.id == auctionId);
    if (auctionIndex != -1) {
      _auctions[auctionIndex] = _auctions[auctionIndex].copyWith(
        status: AuctionStatus.rejected,
      );
    }

    _isLoading.value = false;
    update();
  }
}
