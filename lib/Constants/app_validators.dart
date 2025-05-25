class AppValidators {
  static RegExp emailValidator = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,3}");
  static RegExp emailHeadValidator = RegExp(r'^(?=.*[a-zA-Z])[0-9]*.*');
  static RegExp passwordValidator = RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,12}');
  static RegExp doubleValidator = RegExp(r'^\d+(\.\d+)?$');
}
