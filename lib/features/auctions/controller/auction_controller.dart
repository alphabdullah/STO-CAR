import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/api/api_client.dart' as api;
import '../../../state/auction_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/auction_model.dart';

/// Unified auction controller for both guest and logged-in users
class AuctionController extends GetxController {
  final AuctionState _auctionState = Get.find<AuctionState>();

  final _bidAmount = 0.0.obs;
  final _isLoading = false.obs;

  double get bidAmount => _bidAmount.value;
  bool get isLoading => _isLoading.value;

  void setBidAmount(double amount) => _bidAmount.value = amount;

  void showAuctionDetails(BuildContext context, AuctionModel auction) {
    // Navigate to full-screen details page
    context.push('/auctions/${auction.id}');
  }

  void showBidDialog(BuildContext context, AuctionModel auction) {
    print(
      'AuctionController.showBidDialog: ==========================================',
    );
    print(
      'AuctionController.showBidDialog: Showing bid dialog for auction: ${auction.id}',
    );
    print('AuctionController.showBidDialog: Auction title: ${auction.title}');

    final authState = AuthState();

    // Check authentication and verification before showing bid dialog
    print('AuctionController.showBidDialog: Checking authentication...');
    print(
      'AuctionController.showBidDialog: isAuthenticated: ${authState.isAuthenticated}',
    );
    if (!authState.isAuthenticated) {
      print(
        'AuctionController.showBidDialog: User not authenticated, redirecting to login',
      );
      context.push(AppConstants.routeLogin);
      return;
    }

    print('AuctionController.showBidDialog: Checking verification...');
    print(
      'AuctionController.showBidDialog: isVerified: ${authState.isVerified}',
    );
    if (!authState.isVerified) {
      print(
        'AuctionController.showBidDialog: User not verified, showing snackbar',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your account to place bids'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print(
      'AuctionController.showBidDialog: User authenticated and verified, showing dialog',
    );

    final minBid =
        (auction.currentBid ?? auction.startingBid) +
        AppConstants.minBidIncrement;
    _bidAmount.value = minBid;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Place Bid - ${auction.title}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.currentBid}: ${auction.currentBid ?? auction.startingBid} AED',
              ),
              const SizedBox(height: 8),
              Text('${AppStrings.minimumBid}: $minBid AED'),
              const SizedBox(height: 16),
              Obx(
                () => TextField(
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    setBidAmount(amount);
                  },
                  decoration: InputDecoration(
                    labelText: AppStrings.bidAmount,
                    prefixText: 'AED ',
                    errorText: _bidAmount.value < minBid
                        ? 'Minimum bid is $minBid AED'
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          Obx(
            () => CustomButton(
              text: AppStrings.placeBid,
              onPressed: _bidAmount.value >= minBid
                  ? () {
                      print('AuctionController: Place Bid button pressed!');
                      print('AuctionController: Auction ID: ${auction.id}');
                      print(
                        'AuctionController: Bid Amount: ${_bidAmount.value}',
                      );
                      _placeBid(context, auction.id, _bidAmount.value);
                    }
                  : null,
              isLoading: _isLoading.value,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeBid(
    BuildContext context,
    String auctionId,
    double amount,
  ) async {
    print(
      'AuctionController._placeBid: ==========================================',
    );
    print('AuctionController._placeBid: START - Placing bid');
    print('AuctionController._placeBid: Auction ID: $auctionId');
    print('AuctionController._placeBid: Bid Amount: $amount');
    print(
      'AuctionController._placeBid: ==========================================',
    );

    _isLoading.value = true;

    try {
      print('AuctionController._placeBid: Calling auctionState.placeBid()...');
      final success = await _auctionState.placeBid(auctionId, amount);
      print(
        'AuctionController._placeBid: Received response from placeBid: $success',
      );
      _isLoading.value = false;

      if (context.mounted) {
        Navigator.pop(context);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bid placed successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to place bid. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } on api.ApiException catch (e) {
      _isLoading.value = false;
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      _isLoading.value = false;
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place bid: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
