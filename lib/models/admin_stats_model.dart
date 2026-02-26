/// Admin statistics model for dashboard
/// Matches API response structure from /api/v1/admin/dashboard
class AdminStatsModel {
  // Users stats
  final int totalUsers;
  final int verifiedUsers;
  final int newUsersThisMonth;

  // Auctions stats
  final int totalAuctions;
  final int liveAuctions;
  final int pendingApprovalAuctions;
  final int closedAuctions;

  // Parts stats
  final int totalParts;
  final int availableParts;
  final int soldParts;

  // Bookings stats
  final int totalBookings;
  final int pendingBookings;
  final int todayBookings;
  final int completedBookings;

  // Revenue stats
  final double totalAuctionValue;
  final double totalPartsSold;

  // Legacy fields for backward compatibility
  final double totalRevenue;
  final double totalBids;
  final Map<String, int> auctionsByStatus;
  final Map<String, int> bookingsByStatus;

  const AdminStatsModel({
    // Users
    this.totalUsers = 0,
    this.verifiedUsers = 0,
    this.newUsersThisMonth = 0,
    // Auctions
    this.totalAuctions = 0,
    this.liveAuctions = 0,
    this.pendingApprovalAuctions = 0,
    this.closedAuctions = 0,
    // Parts
    this.totalParts = 0,
    this.availableParts = 0,
    this.soldParts = 0,
    // Bookings
    this.totalBookings = 0,
    this.pendingBookings = 0,
    this.todayBookings = 0,
    this.completedBookings = 0,
    // Revenue
    this.totalAuctionValue = 0.0,
    this.totalPartsSold = 0.0,
    // Legacy fields
    this.totalRevenue = 0.0,
    this.totalBids = 0.0,
    this.auctionsByStatus = const {},
    this.bookingsByStatus = const {},
  });

  /// Safely parse integer from dynamic value (handles String, int, null)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Safely parse double from dynamic value (handles String, double, int, null)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Create AdminStatsModel from API response JSON
  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    // Extract nested data
    final users = json['users'] as Map<String, dynamic>? ?? {};
    final auctions = json['auctions'] as Map<String, dynamic>? ?? {};
    final parts = json['parts'] as Map<String, dynamic>? ?? {};
    final bookings = json['bookings'] as Map<String, dynamic>? ?? {};
    final revenue = json['revenue'] as Map<String, dynamic>? ?? {};

    // Parse values with safety helpers
    final totalUsers = _parseInt(users['total']);
    final verifiedUsers = _parseInt(users['verified']);
    final newUsersThisMonth = _parseInt(users['new_this_month']);

    final totalAuctions = _parseInt(auctions['total']);
    final liveAuctions = _parseInt(auctions['live']);
    final pendingAuctions = _parseInt(auctions['pending']);
    final closedAuctions = _parseInt(auctions['closed']);

    final totalParts = _parseInt(parts['total']);
    final availableParts = _parseInt(parts['available']);
    final soldParts = _parseInt(parts['sold']);

    final totalBookings = _parseInt(bookings['total']);
    final pendingBookings = _parseInt(bookings['pending']);
    final todayBookings = _parseInt(bookings['today']);
    final completedBookings = _parseInt(bookings['completed']);

    final totalAuctionValue = _parseDouble(revenue['total_auction_value']);
    final totalPartsSold = _parseDouble(revenue['total_parts_sold']);

    // Build legacy maps for backward compatibility
    final auctionsByStatus = {
      'live': liveAuctions,
      'pending': pendingAuctions,
      'closed': closedAuctions,
    };

    final bookingsByStatus = {
      'pending': pendingBookings,
      'completed': completedBookings,
      'today': todayBookings,
    };

    return AdminStatsModel(
      totalUsers: totalUsers,
      verifiedUsers: verifiedUsers,
      newUsersThisMonth: newUsersThisMonth,
      totalAuctions: totalAuctions,
      liveAuctions: liveAuctions,
      pendingApprovalAuctions: pendingAuctions,
      closedAuctions: closedAuctions,
      totalParts: totalParts,
      availableParts: availableParts,
      soldParts: soldParts,
      totalBookings: totalBookings,
      pendingBookings: pendingBookings,
      todayBookings: todayBookings,
      completedBookings: completedBookings,
      totalAuctionValue: totalAuctionValue,
      totalPartsSold: totalPartsSold,
      totalRevenue: totalAuctionValue + totalPartsSold,
      totalBids: totalAuctionValue,
      auctionsByStatus: auctionsByStatus,
      bookingsByStatus: bookingsByStatus,
    );
  }

  AdminStatsModel copyWith({
    int? totalUsers,
    int? verifiedUsers,
    int? newUsersThisMonth,
    int? totalAuctions,
    int? liveAuctions,
    int? pendingApprovalAuctions,
    int? closedAuctions,
    int? totalParts,
    int? availableParts,
    int? soldParts,
    int? totalBookings,
    int? pendingBookings,
    int? todayBookings,
    int? completedBookings,
    double? totalAuctionValue,
    double? totalPartsSold,
    double? totalRevenue,
    double? totalBids,
    Map<String, int>? auctionsByStatus,
    Map<String, int>? bookingsByStatus,
  }) {
    return AdminStatsModel(
      totalUsers: totalUsers ?? this.totalUsers,
      verifiedUsers: verifiedUsers ?? this.verifiedUsers,
      newUsersThisMonth: newUsersThisMonth ?? this.newUsersThisMonth,
      totalAuctions: totalAuctions ?? this.totalAuctions,
      liveAuctions: liveAuctions ?? this.liveAuctions,
      pendingApprovalAuctions:
          pendingApprovalAuctions ?? this.pendingApprovalAuctions,
      closedAuctions: closedAuctions ?? this.closedAuctions,
      totalParts: totalParts ?? this.totalParts,
      availableParts: availableParts ?? this.availableParts,
      soldParts: soldParts ?? this.soldParts,
      totalBookings: totalBookings ?? this.totalBookings,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      todayBookings: todayBookings ?? this.todayBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      totalAuctionValue: totalAuctionValue ?? this.totalAuctionValue,
      totalPartsSold: totalPartsSold ?? this.totalPartsSold,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalBids: totalBids ?? this.totalBids,
      auctionsByStatus: auctionsByStatus ?? this.auctionsByStatus,
      bookingsByStatus: bookingsByStatus ?? this.bookingsByStatus,
    );
  }
}
