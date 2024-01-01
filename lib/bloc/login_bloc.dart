import 'dart:async';

import 'package:reactive_architecture/service/abstract/auth_service.dart';
import 'package:rxdart/rxdart.dart';

import '../core/generic_state.dart';
import '../entity/person.dart';

typedef LoginVM = GenericState<LoginType, Person>;
typedef CityVM = GenericState<CityType, String>;

class LoginBloc {
  final AuthService service;

  LoginBloc(this.service);

  final controller = StreamController();
  final loginSubject = BehaviorSubject<LoginVM>();
  final citySubject = BehaviorSubject<CityVM>();

  Person? get lastPerson => loginSubject.valueOrNull?.data;
  String? get lastCity => citySubject.valueOrNull?.data;

  Stream get mainStream => Rx.merge([loginSubject, citySubject]);
  void getPerson() {
    Stream.fromFuture(service.getProfile()).doOnListen(() {
      print("listening........");
      loginSubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      print("error........");
      loginSubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      print("event occurred........ $event");
      loginSubject.sink.add(GenericState.loaded(event));
    });
  }

  void getCity() {
    Stream.fromFuture(service.getCity()).doOnListen(() {
      print("CITY: listening........");
      citySubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      print("CITY: error........");
      citySubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      print("CITY: event occurred........ $event");
      citySubject.sink.add(GenericState.loaded(event));
    });
  }
}

class LoginType {}

class CityType {}
