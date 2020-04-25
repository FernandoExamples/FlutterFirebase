
class CustomException implements Exception {

  static final TIME_OUT_CODE = 1;
  static final INTERNET_CODE = 2;

  String message;
  int code;

  CustomException(this.code, this.message);
}