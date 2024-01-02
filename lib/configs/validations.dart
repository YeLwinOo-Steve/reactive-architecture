import 'dart:async';

class Validations {
  static StreamTransformer<String, String> validateEmail() {
    return StreamTransformer<String, String>.fromHandlers(
        handleData: (email, sink) {
      if (email.isEmpty) {
        sink.addError("Email cannot be null!");
      } else if (!(email.contains('@') || email.contains('.com'))) {
        sink.addError("Email format is wrong!");
      } else {
        sink.add(email);
      }
    });
  }

  static StreamTransformer<String, String> validatePhone() {
    return StreamTransformer<String, String>.fromHandlers(
        handleData: (phone, sink) {
      if (phone.isEmpty) {
        sink.addError("Phone number cannot be empty!");
      } else if (phone.length < 4) {
        sink.addError("Phone number format is wrong!");
      } else {
        sink.add(phone);
      }
    });
  }
}
