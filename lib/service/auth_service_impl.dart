import 'dart:math';

import 'package:faker/faker.dart' hide Person;
import 'package:reactive_architecture/service/abstract/auth_service.dart';

import '../entity/person.dart';

class AuthServiceImpl extends AuthService {
  final faker = Faker.withGenerator(RandomGenerator(seed: 63833423));

  @override
  Future<Person?> getProfile() async {
    await Future.delayed(const Duration(seconds: 3));
    final rand = Random().nextInt(3);
    if (rand == 2) throw Exception('random is 2');
    return Person(
      name: faker.person.name(),
      email: faker.internet.email(),
      phone: faker.phoneNumber.us(),
    );
  }

  @override
  Future<String?> getCity() async {
    await Future.delayed(const Duration(seconds: 4));
    return faker.address.city();
  }
}
