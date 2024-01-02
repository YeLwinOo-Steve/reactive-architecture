import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:reactive_architecture/service/abstract/auth_service.dart';
import 'package:rxdart/rxdart.dart';

import '../alias/login_alias.dart';
import '../configs/validations.dart';
import '../core/base_bloc.dart';
import '../core/generic_state.dart';
import '../entity/person.dart';

class LoginBloc extends BaseBloc {
  final AuthService service;

  LoginBloc(this.service);

  @override
  void onInit() {
    super.onInit();
    listenFormState();
    getPerson();
  }

  @override
  void onDispose() {
    super.onDispose();
    loginSubject.close();
    citySubject.close();
    _emailSubject.close();
    _phoneSubject.close();
    formSubject.close();
  }

  @override
  Stream get mainStream => Rx.merge(
      [loginSubject, citySubject, _emailSubject, _phoneSubject, formSubject]);
  final loginSubject = BehaviorSubject<LoginVM>();
  final citySubject = BehaviorSubject<CityVM>();

  final _emailSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final formSubject = BehaviorSubject<FormVM>();

  ValueChanged<String> get onEmailChanged => _emailSubject.sink.add;
  ValueChanged<String> get onPhoneChanged => _phoneSubject.sink.add;

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(Validations.validateEmail());
  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(Validations.validatePhone());
  Stream<bool> get formStream =>
      Rx.combineLatest2(emailStream, phoneStream, (a, b) => _validate(a, b));

  bool _validate(String e, String p) {
    print("________email $e --------- ${_emailSubject.valueOrNull}");
    print("________phone $p --------- ${_phoneSubject.valueOrNull}");
    return identical(e, _emailSubject.valueOrNull) &&
            identical(p, _phoneSubject.valueOrNull)
        ? true
        : false;
  }

  Person? get lastPerson => loginSubject.valueOrNull?.data;
  String? get lastCity => citySubject.valueOrNull?.data;

  bool get lastFormState => formSubject.valueOrNull?.data ?? false;

  void listenFormState() {
    formStream.listen((event) {
      formSubject.sink.add(GenericState.loaded(event));
    });
  }

  void getPerson() {
    Stream.fromFuture(service.getProfile()).doOnListen(() {
      loginSubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      loginSubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      loginSubject.sink.add(GenericState.loaded(event));
    });
  }

  void getCity() {
    Stream.fromFuture(service.getCity()).doOnListen(() {
      citySubject.sink.add(GenericState.loading());
    }).doOnError((err, stacktrace) {
      citySubject.sink.add(GenericState.requestError(err.toString()));
    }).listen((event) {
      citySubject.sink.add(GenericState.loaded(event));
    });
  }
}
