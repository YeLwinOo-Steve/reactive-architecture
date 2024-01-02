import '../core/generic_state.dart';
import '../entity/address.dart';

typedef ContinentVM = GenericState<ContinentType, List<String?>>;
typedef CountryVM = GenericState<CountryType, List<String?>>;
typedef AddressVM = GenericState<AddressType, Address?>;

class ContinentType {}

class CountryType {}

class AddressType {}
