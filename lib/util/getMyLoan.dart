import 'dart:convert';

List<DueLoans> dueLoansFromJson(String str) => List<DueLoans>.from(json.decode(str).map((x) => DueLoans.fromJson(x)));

String dueLoansToJson(List<DueLoans> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DueLoans {
    DueLoans({
        this.borrower,
        this.due,
        this.interest,
        this.lastDueDate,
        this.loanId,
        this.nextDue,
        this.nextDueDate,
        this.penalty,
        this.principal,
        this.product,
        this.repaymentMode,
        this.totalBalance,
        this.totalPaid,
    });

    String borrower;
    int due;
    int interest;
    String lastDueDate;
    int loanId;
    int nextDue;
    String nextDueDate;
    int penalty;
    int principal;
    String product;
    String repaymentMode;
    int totalBalance;
    int totalPaid;

    factory DueLoans.fromJson(Map<String, dynamic> json) => DueLoans(
        borrower: json["borrower"],
        due: json["due"],
        interest: json["interest"],
        lastDueDate: json["lastDueDate"],
        loanId: json["loanId"],
        nextDue: json["nextDue"],
        nextDueDate: json["nextDueDate"],
        penalty: json["penalty"],
        principal: json["principal"],
        product: json["product"],
        repaymentMode: json["repaymentMode"],
        totalBalance: json["totalBalance"],
        totalPaid: json["totalPaid"],
    );

    Map<String, dynamic> toJson() => {
        "borrower": borrower,
        "due": due,
        "interest": interest,
        "lastDueDate": lastDueDate,
        "loanId": loanId,
        "nextDue": nextDue,
        "nextDueDate": nextDueDate,
        "penalty": penalty,
        "principal": principal,
        "product": product,
        "repaymentMode": repaymentMode,
        "totalBalance": totalBalance,
        "totalPaid": totalPaid,
    };
}
