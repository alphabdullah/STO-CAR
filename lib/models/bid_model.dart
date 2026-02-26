/// Bid model representing auction bid
class BidModel {
  final String id;
  final String auctionId;
  final String userId;
  final String userName;
  final double amount;
  final DateTime timestamp;
  final bool isWinning;

  const BidModel({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.timestamp,
    this.isWinning = false,
  });

  BidModel copyWith({
    String? id,
    String? auctionId,
    String? userId,
    String? userName,
    double? amount,
    DateTime? timestamp,
    bool? isWinning,
  }) {
    return BidModel(
      id: id ?? this.id,
      auctionId: auctionId ?? this.auctionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      isWinning: isWinning ?? this.isWinning,
    );
  }

  /// Create BidModel from API response JSON
  /// 
  /// Expects structure:
  /// {
  ///   "id": 1,
  ///   "auction_id": 2,
  ///   "user_id": 4,
  ///   "user": { "id": 4, "name": "Test User" },
  ///   "amount": 60000,
  ///   "created_at": "2026-01-17T08:56:28.000000Z",
  ///   "is_winning": true
  /// }
  factory BidModel.fromJson(Map<String, dynamic> json, String auctionId) {
    // Parse user object if present
    String? userName;
    String? userId;
    if (json['user'] != null) {
      final user = json['user'] as Map<String, dynamic>;
      userName = user['name']?.toString() ?? user['email']?.toString();
      userId = user['id']?.toString() ?? json['user_id']?.toString();
    } else {
      userId = json['user_id']?.toString();
      userName = json['user_name']?.toString() ?? 'Unknown User';
    }

    final timestamp = json['created_at'] != null || json['timestamp'] != null
        ? DateTime.tryParse((json['created_at'] ?? json['timestamp']).toString())
        : null;

    return BidModel(
      id: json['id']?.toString() ?? '',
      auctionId: auctionId,
      userId: userId ?? '',
      userName: userName ?? 'Unknown User',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      timestamp: timestamp ?? DateTime.now(),
      isWinning: json['is_winning'] == true || json['isWinning'] == true,
    );
  }
}

