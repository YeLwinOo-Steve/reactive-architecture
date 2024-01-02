import '../core/generic_state.dart';
import '../entity/person.dart';

typedef LoginVM = GenericState<LoginType, Person>;
typedef CityVM = GenericState<CityType, String>;

class LoginType {}

class CityType {}
