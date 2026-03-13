import 'package:flutter/material.dart';
import '../../../models/auction_model.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Redesigned Auction Card - Premium, Responsive, and Overflow-Safe
class AuctionCard extends StatelessWidget {
  final AuctionModel auction;
  final VoidCallback? onBid;
  final VoidCallback? onView;
  final VoidCallback? onTap;
  final bool showBidButton;
  final bool showViewButton;
  final bool isBidded;
  final bool isOutbid;
  final bool isAuthenticated;

  const AuctionCard({
    super.key,
    required this.auction,
    this.onBid,
    this.onView,
    this.onTap,
    required this.showBidButton,
    this.showViewButton = false,
    this.isBidded = false,
    this.isOutbid = false,
    this.isAuthenticated = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final timeRemaining = auction.timeRemaining;
    final bidCount = auction.bids.length;

    // Safe responsive sizes
    const double cardHeight =
        155.0; // Fixed height to prevent vertical overflow
    final double imageWidth = screenWidth * 0.38;
    const double borderRadius = 12.0;

    return Container(
      height: cardHeight,
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppDesign.getBgSecondary(context),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppDesign.getBorder(context).withValues(alpha: 0.5),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                .withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? onView,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: Image Section
                SizedBox(
                  width: imageWidth,
                  child: _buildImageSection(context, imageWidth, borderRadius),
                ),

                // Right: Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lot & Live Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.lotNumber(auction.id),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: AppDesign.getTextTertiary(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (auction.isLive) _buildLiveBadge(context),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Title (Car Name)
                        Text(
                          auction.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppDesign.getTextPrimary(context),
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Year
                        Text(
                          auction.carYear.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppDesign.getTextTertiary(context),
                          ),
                        ),

                        const Spacer(), // Pushes info chips to center/bottom
                        // Info Chips (Bids & Time)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniInfo(
                                context,
                                AppLocalizations.of(context)!.bids,
                                bidCount.toString(),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _buildMiniInfo(
                                context,
                                AppLocalizations.of(context)!.time,
                                _formatShortTime(timeRemaining),
                                color: timeRemaining.inHours < 24
                                    ? AppTheme.warning
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Current Price & Details Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.currentBid,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: AppDesign.getTextTertiary(context),
                                    ),
                                  ),
                                  Text(
                                    '${auction.currentBid ?? auction.startingBid} AED',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.redPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            _buildArrowIcon(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 2.5, backgroundColor: AppTheme.success),
          const SizedBox(width: 3),
          Text(
            AppLocalizations.of(context)!.live,
            style: TextStyle(
              fontSize: 7,
              color: AppTheme.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(
    BuildContext context, String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppDesign.getBgElevated(context),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 7, color: AppDesign.getTextTertiary(context)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color ?? AppDesign.getTextPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.redPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 10,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, double width, double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(radius)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppDesign.getBgElevated(context),
            child: auction.images.isNotEmpty
                ? Image.network(
                    auction.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.redPrimary,
                          ),
                        ),
                      );
                    },
                  )
                : _buildPlaceholder(context),
          ),
          // Photo Count Badge
          if (auction.images.length > 1)
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      size: 8,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${auction.images.length}',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bid Status (Winning/Outbid)
          if (isBidded)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isOutbid ? AppTheme.warning : AppTheme.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOutbid ? Icons.trending_down : Icons.trending_up,
                  size: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.directions_car_rounded,
        size: 40,
        color: AppDesign.getTextTertiary(context),
      ),
    );
  }

  String _formatShortTime(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }
}
