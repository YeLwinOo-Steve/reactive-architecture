import 'package:faker/faker.dart' hide Address;
import 'package:reactive_architecture/entity/address.dart';

import 'abstract/location_service.dart';

class LocationServiceImpl extends LocationService {
  final faker = Faker.withGenerator(RandomGenerator(seed: 63833423));

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<Address?> getAddress() async {
    await delay();
    return Address(
      city: faker.address.city(),
      zipCode: faker.address.zipCode(),
      street: faker.address.streetName(),
    );
  }

  @override
  Future<List<String>?> getContinent() async {
    await delay();
    return [
      "Asia",
      "Africa",
      "Europe",
      "North America",
      "South America",
      "Australia",
      "Antarctica"
    ];
  }

  @override
  Future<List<String>?> getCountry() async {
    await delay();
    return [
      "Park Min Young",
      "Kim Go Eun",
      "Park Bo Young",
      "Kim Da Mi",
      "Kim Ji Won",
      "Kim Tae Yi",
      "Shin Hye Sun",
    ];
  }
}
