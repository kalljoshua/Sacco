import 'dart:convert';

UserTransactions userTransactionsFromJson(String str) => UserTransactions.fromJson(json.decode(str));

String userTransactionsToJson(UserTransactions data) => json.encode(data.toJson());

class UserTransactions {
    UserTransactions({
        this.userTransactions,
    });

    List<UserTransaction> userTransactions;

    factory UserTransactions.fromJson(Map<String, dynamic> json) => UserTransactions(
        userTransactions: List<UserTransaction>.from(json["userTransactions"].map((x) => UserTransaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userTransactions": List<dynamic>.from(userTransactions.map((x) => x.toJson())),
    };
}

class UserTransaction {
    UserTransaction({
        this.id,
        this.date,
        this.amount,
        this.acctFrom,
        this.acctTo,
        this.userName,
        this.transactionType,
        this.status,
    });

    int id;
    DateTime date;
    double amount;
    String acctFrom;
    String acctTo;
    String userName;
    String transactionType;
    String status;

    factory UserTransaction.fromJson(Map<String, dynamic> json) => UserTransaction(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        amount: json["amount"],
        acctFrom: json["acctFrom"],
        acctTo: json["acctTo"],
        userName: json["userName"],
        transactionType: json["transactionType"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "acctFrom": acctFrom,
        "acctTo": acctTo,
        "userName": userName,
        "transactionType": transactionType,
        "status": status,
    };
}
