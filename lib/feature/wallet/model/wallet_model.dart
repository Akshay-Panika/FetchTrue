import '../../auth/model/sign_in_model.dart';

class WalletModel {
  final String id;
  final UserModel user;
  final int balance;
  final int totalCredits;
  final int totalDebits;
  final bool isActive;
  final DateTime lastTransactionAt;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.user,
    required this.balance,
    required this.totalCredits,
    required this.totalDebits,
    required this.isActive,
    required this.lastTransactionAt,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'],
      user: UserModel.fromJson(json['userId']),
      balance: json['balance'],
      totalCredits: json['totalCredits'],
      totalDebits: json['totalDebits'],
      isActive: json['isActive'],
      lastTransactionAt: DateTime.parse(json['lastTransactionAt']),
      transactions: (json['transactions'] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class TransactionModel {
  final String type;
  final int amount;
  final String description;
  final String referenceId;
  final String method;
  final String source;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.description,
    required this.referenceId,
    required this.method,
    required this.source,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      referenceId: json['referenceId'],
      method: json['method'],
      source: json['source'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
