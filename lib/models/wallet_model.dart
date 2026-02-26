/// Wallet model representing user wallet state
class WalletModel {
  final String userId;
  final double balance;
  final bool isVerified;
  final double? depositAmount;
  final DateTime? depositDate;
  final List<WalletTransaction> transactions;

  const WalletModel({
    required this.userId,
    this.balance = 0.0,
    this.isVerified = false,
    this.depositAmount,
    this.depositDate,
    this.transactions = const [],
  });

  WalletModel copyWith({
    String? userId,
    double? balance,
    bool? isVerified,
    double? depositAmount,
    DateTime? depositDate,
    List<WalletTransaction>? transactions,
  }) {
    return WalletModel(
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      isVerified: isVerified ?? this.isVerified,
      depositAmount: depositAmount ?? this.depositAmount,
      depositDate: depositDate ?? this.depositDate,
      transactions: transactions ?? this.transactions,
    );
  }
}

/// Wallet transaction model
class WalletTransaction {
  final String id;
  final String type; // 'deposit', 'withdrawal', 'bid', 'purchase'
  final double amount;
  final DateTime timestamp;
  final String? description;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
    this.description,
  });

  /// Create WalletTransaction from JSON
  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'deposit',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      description: json['description']?.toString(),
    );
  }
}

/// Wallet summary model matching API response
class WalletSummary {
  final double balance;
  final double pendingBalance;
  final double totalDeposits;
  final double totalWithdrawals;
  final double thisMonthDeposits;
  final double thisMonthWithdrawals;
  final List<WalletTransaction> recentTransactions;

  const WalletSummary({
    required this.balance,
    required this.pendingBalance,
    required this.totalDeposits,
    required this.totalWithdrawals,
    required this.thisMonthDeposits,
    required this.thisMonthWithdrawals,
    this.recentTransactions = const [],
  });

  /// Create WalletSummary from JSON
  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    final transactions = json['recent_transactions'] as List<dynamic>? ?? [];
    
    return WalletSummary(
      balance: (json['balance'] is int)
          ? (json['balance'] as int).toDouble()
          : (json['balance'] as num?)?.toDouble() ?? 0.0,
      pendingBalance: (json['pending_balance'] is int)
          ? (json['pending_balance'] as int).toDouble()
          : (json['pending_balance'] as num?)?.toDouble() ?? 0.0,
      totalDeposits: (json['total_deposits'] is int)
          ? (json['total_deposits'] as int).toDouble()
          : (json['total_deposits'] as num?)?.toDouble() ?? 0.0,
      totalWithdrawals: (json['total_withdrawals'] is int)
          ? (json['total_withdrawals'] as int).toDouble()
          : (json['total_withdrawals'] as num?)?.toDouble() ?? 0.0,
      thisMonthDeposits: (json['this_month_deposits'] is int)
          ? (json['this_month_deposits'] as int).toDouble()
          : (json['this_month_deposits'] as num?)?.toDouble() ?? 0.0,
      thisMonthWithdrawals: (json['this_month_withdrawals'] is int)
          ? (json['this_month_withdrawals'] as int).toDouble()
          : (json['this_month_withdrawals'] as num?)?.toDouble() ?? 0.0,
      recentTransactions: transactions
          .map((t) => WalletTransaction.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

