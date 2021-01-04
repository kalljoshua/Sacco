class LoginResponse {
  bool status;
  String message;

  LoginResponse(status, message) {
    this.status = status;
    this.message = message;
  }

  bool getStatus() {
    return this.status;
  }

  String getMessage() {
    return this.message;
  }
}
