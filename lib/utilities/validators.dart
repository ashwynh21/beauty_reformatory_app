
bool isEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
}
bool isName(String name) {
  return RegExp(r"^(?=.{1,40}$)[a-zA-Z]+(?:[-'\s][a-zA-Z]+)*$").hasMatch(name);
}
bool isPassword(String password) {
  return RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$").hasMatch(password);
}
bool isNumber(String number) {
  return RegExp(r"(268)?(\+268)?([7])+([689])+([0-9]{6})").hasMatch(number);
}
bool isOTP(String message){
  return RegExp(r"([0-9]{4,6})").hasMatch(message);
}
bool isURL(String url) {
  return RegExp(r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)").hasMatch(url);
}