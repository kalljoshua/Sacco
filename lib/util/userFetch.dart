import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.personDto,
        this.accountDto,
        this.workDto,
        this.bankDto,
    });

    PersonDto personDto;
    AccountDto accountDto;
    WorkDto workDto;
    dynamic bankDto;

    factory User.fromJson(Map<String, dynamic> json) => User(
        personDto: PersonDto.fromJson(json["personDto"]),
        accountDto: AccountDto.fromJson(json["accountDto"]),
        workDto: WorkDto.fromJson(json["workDto"]),
        bankDto: json["bankDto"],
    );

    Map<String, dynamic> toJson() => {
        "personDto": personDto.toJson(),
        "accountDto": accountDto.toJson(),
        "workDto": workDto.toJson(),
        "bankDto": bankDto,
    };
}

class AccountDto {
    AccountDto({
        this.id,
        this.totalSavings,
        this.totalShares,
        this.pendingFee,
        this.memberNo,
        this.position,
    });

    int id;
    double totalSavings;
    double totalShares;
    double pendingFee;
    String memberNo;
    String position;

    factory AccountDto.fromJson(Map<String, dynamic> json) => AccountDto(
        id: json["id"],
        totalSavings: json["totalSavings"],
        totalShares: json["totalShares"],
        pendingFee: json["pendingFee"],
        memberNo: json["memberNo"],
        position: json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "totalSavings": totalSavings,
        "totalShares": totalShares,
        "pendingFee": pendingFee,
        "memberNo": memberNo,
        "position": position,
    };
}

class PersonDto {
    PersonDto({
        this.id,
        this.firstName,
        this.lastName,
        this.nin,
        this.mobile,
        this.email,
        this.dob,
        this.gender,
        this.residence,
    });

    int id;
    String firstName;
    String lastName;
    String nin;
    String mobile;
    String email;
    DateTime dob;
    String gender;
    String residence;

    factory PersonDto.fromJson(Map<String, dynamic> json) => PersonDto(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        nin: json["nin"],
        mobile: json["mobile"],
        email: json["email"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        residence: json["residence"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "nin": nin,
        "mobile": mobile,
        "email": email,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "residence": residence,
    };
}

class WorkDto {
    WorkDto({
        this.id,
        this.companyName,
        this.employeeId,
        this.toe,
        this.workStation,
        this.basicSalary,
        this.job,
        this.payrollSaving,
        this.payrollShares,
    });

    int id;
    String companyName;
    dynamic employeeId;
    dynamic toe;
    dynamic workStation;
    double basicSalary;
    dynamic job;
    double payrollSaving;
    double payrollShares;

    factory WorkDto.fromJson(Map<String, dynamic> json) => WorkDto(
        id: json["id"],
        companyName: json["companyName"],
        employeeId: json["employeeId"],
        toe: json["toe"],
        workStation: json["workStation"],
        basicSalary: json["basicSalary"],
        job: json["job"],
        payrollSaving: json["payrollSaving"],
        payrollShares: json["payrollShares"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "employeeId": employeeId,
        "toe": toe,
        "workStation": workStation,
        "basicSalary": basicSalary,
        "job": job,
        "payrollSaving": payrollSaving,
        "payrollShares": payrollShares,
    };
}
