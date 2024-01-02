import '../core/generic_state.dart';
import '../entity/person.dart';

typedef LoginVM = GenericState<LoginType, Person>;
typedef CityVM = GenericState<CityType, String>;
typedef FormVM = GenericState<FormType, bool>;

class LoginType {}

class CityType {}

class FormType {}
