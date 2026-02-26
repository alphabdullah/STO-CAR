import 'bid_model.dart';

/// Auction status enumeration
enum AuctionStatus { pendingApproval, approved, live, closed, rejected }

/// Auction model representing car auction state
class AuctionModel {
  final String id;
  final String title;
  final String description;
  final String carMake;
  final String carModel;
  final int carYear;
  final String? carImageUrl;
  final List<String> images;
  final double startingBid;
  final double? currentBid;
  final String? currentBidderId;
  final AuctionStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  final String? createdBy;
  final List<BidModel> bids;

  const AuctionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.carMake,
    required this.carModel,
    required this.carYear,
    this.carImageUrl,
    this.images = const [],
    required this.startingBid,
    this.currentBid,
    this.currentBidderId,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    this.createdBy,
    this.bids = const [],
  });

  bool get isLive => status == AuctionStatus.live;
  bool get isClosed => status == AuctionStatus.closed;
  bool get isPendingApproval => status == AuctionStatus.pendingApproval;

  Duration get timeRemaining {
    if (isClosed) return Duration.zero;
    final now = DateTime.now();
    if (endTime.isBefore(now)) return Duration.zero;
    return endTime.difference(now);
  }

  AuctionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? carMake,
    String? carModel,
    int? carYear,
    String? carImageUrl,
    List<String>? images,
    double? startingBid,
    double? currentBid,
    String? currentBidderId,
    AuctionStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    String? createdBy,
    List<BidModel>? bids,
  }) {
    return AuctionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      carYear: carYear ?? this.carYear,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      images: images ?? this.images,
      startingBid: startingBid ?? this.startingBid,
      currentBid: currentBid ?? this.currentBid,
      currentBidderId: currentBidderId ?? this.currentBidderId,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      bids: bids ?? this.bids,
    );
  }

  /// Create AuctionModel from API response JSON
  ///
  /// Expects structure from /api/v1/auctions:
  /// {
  ///   "id": 1,
  ///   "title": "2020 BMW 3 Series",
  ///   "slug": "2020-bmw-3-series-696b4ebcb7109",
  ///   "car_make": "BMW",
  ///   "car_model": "3 Series",
  ///   "car_year": 2020,
  ///   "starting_bid": 50000,
  ///   "current_bid": 52000,
  ///   "minimum_bid": 52500,
  ///   "bid_increment": 500,
  ///   "status": "live",
  ///   "is_live": true,
  ///   "is_closed": false,
  ///   "bids_count": 0,
  ///   "views_count": 150,
  ///   "start_time": "2026-01-16T08:56:28.000000Z",
  ///   "end_time": "2026-01-19T08:56:28.000000Z",
  ///   "time_remaining": 169404,
  ///   "featured_image": null,
  ///   "is_featured": true,
  ///   "creator": { "id": 3, "name": "Admin" },
  ///   "current_bidder": { "id": 4, "name": "Test User" },
  ///   "created_at": "2026-01-17T08:56:28.000000Z"
  /// }
  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    // Parse creator object if present
    String? createdBy;
    if (json['creator'] != null) {
      final creator = json['creator'] as Map<String, dynamic>;
      createdBy = creator['name']?.toString() ?? creator['email']?.toString();
    }

    // Parse current_bidder to get currentBidderId
    String? currentBidderId;
    if (json['current_bidder'] != null) {
      final bidder = json['current_bidder'] as Map<String, dynamic>;
      currentBidderId = bidder['id']?.toString();
    }

    print(
      'AuctionModel.fromJson: Parsing auction ID: ${json['id']}, title: ${json['title']}, status: ${json['status']}',
    );

    // Determine status from API response
    AuctionStatus status;
    final statusStr = json['status']?.toString().toLowerCase() ?? '';
    final isLive = json['is_live'] == true;
    final isClosed = json['is_closed'] == true;

    if (isClosed) {
      status = AuctionStatus.closed;
    } else if (statusStr == 'pending_approval' || statusStr == 'pending') {
      status = AuctionStatus.pendingApproval;
    } else if (isLive || statusStr == 'live') {
      status = AuctionStatus.live;
    } else if (statusStr == 'approved') {
      status = AuctionStatus.approved;
    } else if (statusStr == 'rejected') {
      status = AuctionStatus.rejected;
    } else {
      // Default to pending if unclear
      status = AuctionStatus.pendingApproval;
    }

    // Parse dates
    final startTime = json['start_time'] != null
        ? DateTime.tryParse(json['start_time'].toString())
        : null;
    final endTime = json['end_time'] != null
        ? DateTime.tryParse(json['end_time'].toString())
        : null;
    final createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null;

    return AuctionModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      carMake: json['car_make']?.toString() ?? '',
      carModel: json['car_model']?.toString() ?? '',
      carYear: (json['car_year'] as num?)?.toInt() ?? 0,
      carImageUrl: _cleanImageUrl(
        json['featured_image']?.toString() ?? json['car_image_url']?.toString(),
      ),
      images: () {
        final List<String> imagesList = [];

        // Check for 'images' or 'gallery' field
        final rawImages = json['images'] ?? json['gallery'];

        if (rawImages != null) {
          if (rawImages is List) {
            imagesList.addAll(
              rawImages
                  .map((e) => _cleanImageUrl(e.toString()) ?? '')
                  .where((e) => e.isNotEmpty),
            );
          } else if (rawImages is String && rawImages.isNotEmpty) {
            // Handle comma separated string or JSON-like string
            if (rawImages.startsWith('[') && rawImages.endsWith(']')) {
              // Try to parse basic JSON array if it's a string
              try {
                final cleaned = rawImages
                    .substring(1, rawImages.length - 1)
                    .split(',')
                    .map(
                      (e) => e.trim().replaceAll('"', '').replaceAll("'", ""),
                    );
                imagesList.addAll(
                  cleaned
                      .map((e) => _cleanImageUrl(e) ?? '')
                      .where((e) => e.isNotEmpty),
                );
              } catch (_) {}
            } else {
              imagesList.addAll(
                rawImages
                    .split(',')
                    .map((e) => _cleanImageUrl(e.trim()) ?? '')
                    .where((e) => e.isNotEmpty),
              );
            }
          }
        }

        // Ensure main image is included and is at the start
        final mainImage = _cleanImageUrl(
          json['featured_image']?.toString() ??
              json['car_image_url']?.toString(),
        );

        if (mainImage != null && !imagesList.contains(mainImage)) {
          imagesList.insert(0, mainImage);
        } else if (mainImage != null && imagesList.contains(mainImage)) {
          // Move main image to start if it's elsewhere
          imagesList.remove(mainImage);
          imagesList.insert(0, mainImage);
        }

        return imagesList;
      }(),
      startingBid: (json['starting_bid'] as num?)?.toDouble() ?? 0.0,
      currentBid: json['current_bid'] != null
          ? (json['current_bid'] as num?)?.toDouble()
          : null,
      currentBidderId: currentBidderId ?? json['current_bidder_id']?.toString(),
      status: status,
      startTime: startTime ?? DateTime.now(),
      endTime: endTime ?? DateTime.now().add(const Duration(days: 7)),
      createdAt: createdAt ?? DateTime.now(),
      createdBy: createdBy,
      bids: _parseBids(
        json,
        json['id']?.toString() ?? '',
      ), // Parse bids if present
    );
  }

  /// Parse bids array from JSON
  static List<BidModel> _parseBids(
    Map<String, dynamic> json,
    String auctionId,
  ) {
    if (json['bids'] == null || json['bids'] is! List) {
      return const [];
    }

    try {
      final bidsList = json['bids'] as List<dynamic>;
      return bidsList
          .map(
            (bidJson) =>
                BidModel.fromJson(bidJson as Map<String, dynamic>, auctionId),
          )
          .toList();
    } catch (e) {
      print('AuctionModel: Error parsing bids - $e');
      return const [];
    }
  }

  /// Helper to clean and format image URLs
  static String? _cleanImageUrl(String? url) {
    if (url == null || url.isEmpty || url == 'null') return null;

    // If it's a full URL and already looks like a valid uploaded path,
    // keep it as-is (the API often returns bidssync.com/data-upload/...).
    if (url.startsWith('http')) {
      if (url.contains('/data-upload/uploads/')) return url;
      if (url.contains('data-upload.bidssync.com/data-upload/')) return url;

      // Some responses might omit the /data-upload/ segment on the upload host.
      if (url.contains('data-upload.bidssync.com/') &&
          !url.contains('data-upload.bidssync.com/data-upload/')) {
        return url.replaceFirst(
          'data-upload.bidssync.com/',
          'data-upload.bidssync.com/data-upload/',
        );
      }
    }

    // Otherwise, normalize to a relative path we can prefix with the correct base.
    String relativePath = url;
    if (url.startsWith('http')) {
      // Extract the path after 'uploads/auctions/' if present
      final index = url.indexOf('uploads/auctions/');
      if (index != -1) {
        relativePath = url.substring(index);
      } else {
        // Fallback: if it's just a filename at end of URL
        final lastSlash = url.lastIndexOf('/');
        if (lastSlash != -1) {
          relativePath = 'uploads/auctions/' + url.substring(lastSlash + 1);
        }
      }
    }

    // Ensure relative path starts correctly
    final cleanPath = relativePath.startsWith('/')
        ? relativePath.substring(1)
        : relativePath;

    // Ensure it starts with uploads/auctions/ if it's just a filename or partial path
    String finalPath = cleanPath;
    if (!finalPath.startsWith('uploads/')) {
      if (finalPath.startsWith('auctions/')) {
        finalPath = 'uploads/$finalPath';
      } else {
        finalPath = 'uploads/auctions/$finalPath';
      }
    }

    // Use main API domain path (matches featured_image in API response)
    return 'https://bidssync.com/data-upload/$finalPath';
  }
}
