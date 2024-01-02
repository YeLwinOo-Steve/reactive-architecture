import '../../entity/address.dart';

abstract class LocationService {
  Future<List<String>?> getContinent();
  Future<List<String>?> getCountry();
  Future<Address?> getAddress();
}
