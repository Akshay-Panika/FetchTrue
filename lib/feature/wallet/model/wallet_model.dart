import '../../more/model/user_model.dart';

class WalletModel {
  final String id;
  final UserModel user;
  final int balance;
  final int selfEarnings;
  final int referralEarnings;
  final int totalCredits;
  final int totalDebits;
  final bool isActive;
  final DateTime lastTransactionAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.user,
    required this.balance,
    required this.selfEarnings,
    required this.referralEarnings,
    required this.totalCredits,
    required this.totalDebits,
    required this.isActive,
    required this.lastTransactionAt,
    required this.createdAt,
    required this.updatedAt,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['userId']),
      balance: json['balance'] ?? 0,
      selfEarnings: json['selfEarnings'] ?? 0,
      referralEarnings: json['referralEarnings'] ?? 0,
      totalCredits: json['totalCredits'] ?? 0,
      totalDebits: json['totalDebits'] ?? 0,
      isActive: json['isActive'] ?? false,
      lastTransactionAt: DateTime.parse(json['lastTransactionAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class TransactionModel {
  final String type;
  final String leadId;
  final String commissionFrom;
  final int amount;
  final String description;
  final String referenceId;
  final String method;
  final String source;
  final String status;
  final int balanceAfterTransaction;
  final DateTime createdAt;

  TransactionModel({
    required this.type,
    required this.leadId,
    required this.commissionFrom,
    required this.amount,
    required this.description,
    required this.referenceId,
    required this.method,
    required this.source,
    required this.status,
    required this.balanceAfterTransaction,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'] ?? '',
      leadId: json['leadId'] ?? '',
      commissionFrom: json['commissionFrom'] ?? '',
      amount: json['amount'] ?? 0,
      description: json['description'] ?? '',
      referenceId: json['referenceId'] ?? '',
      method: json['method'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
      balanceAfterTransaction: json['balanceAfterTransaction'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
