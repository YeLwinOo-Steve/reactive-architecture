extension Validations on String {
  String? validateEmail() {
    if (isEmpty) return "Email cannot be null";
    if (!(contains('@') || contains('.com'))) return "Email format is wrong!";
    return null;
  }

  String? phoneNumber() {
    if (isEmpty) return "Phone number cannot be empty!";
    if (length < 9) return "Phone number format is wrong!";
    return null;
  }
}
