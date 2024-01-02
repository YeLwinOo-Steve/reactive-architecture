import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../alias/home_alias.dart';
import '../core/base_bloc.dart';
import '../core/generic_state.dart';
import '../entity/address.dart';
import '../service/abstract/location_service.dart';

class HomeBloc extends BaseBloc {
  final LocationService service;
  HomeBloc(this.service);

  @override
  Stream get mainStream => Rx.merge([
        continentSubject,
        countrySubject,
        addressSubject,
      ]);

  @override
  void onDispose() {
    continentSubject.close();
    countrySubject.close();
    addressSubject.close();
    super.onDispose();
  }

  final continentSubject = BehaviorSubject<ContinentVM>();
  final countrySubject = BehaviorSubject<CountryVM>();
  final addressSubject = BehaviorSubject<AddressVM>();

  List<String?> get lastContinents => continentSubject.valueOrNull?.data ?? [];
  List<String?> get lastCountries => countrySubject.valueOrNull?.data ?? [];
  Address? get lastAddress => addressSubject.valueOrNull?.data;

  String? selectedContinent;
  String? selectedCountry;
  void changeContinent(String? continent) {
    selectedContinent = continent;
    addressSubject.drain(null);
    getCountries();
  }

  void changeCountry(String? country) {
    selectedCountry = country;
    getAddress();
  }

  void getContinents() {
    Stream.fromFuture(service.getContinent()).doOnListen(() {
      continentSubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      continentSubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      print("event occurred........ $event");
      continentSubject.sink.add(GenericState.loaded(event));
      changeContinent(event?.first);
    });
  }

  void getCountries() {
    Stream.fromFuture(service.getCountry()).doOnListen(() {
      countrySubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      countrySubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      print("event occurred........ $event");
      countrySubject.sink.add(GenericState.loaded(event));
      changeCountry(event?.first);
    });
  }

  void getAddress() {
    Stream.fromFuture(service.getAddress()).doOnListen(() {
      addressSubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      addressSubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      print("event occurred........ $event");
      addressSubject.sink.add(GenericState.loaded(event));
    });
  }
}
