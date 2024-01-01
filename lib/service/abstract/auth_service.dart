import '../../entity/person.dart';

abstract class AuthService {
  Future<Person?> getProfile();
  Future<String?> getCity();
}
