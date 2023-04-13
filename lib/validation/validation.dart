
class Validation{

static bool validateEmail(String value) {
  String emailValid = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(emailValid);
  return regExp.hasMatch(value);
}

}