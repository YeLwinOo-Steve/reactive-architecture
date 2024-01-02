enum State { initial, loading, loaded, requestError, serverError }

class GenericState<T extends Object, D> {
  D? data;
  T? type;
  State? state;
  String? message;

  GenericState(
      {this.data, this.state = State.initial, this.message, this.type});
  factory GenericState.init() => GenericState<T, D>(state: State.initial);
  factory GenericState.initWithData(D? data) =>
      GenericState<T, D>(data: data, state: State.initial);
  factory GenericState.loading() => GenericState<T, D>(state: State.loading);
  factory GenericState.loaded(D? data) =>
      GenericState<T, D>(data: data, state: State.loaded);
  factory GenericState.requestError(String? message) =>
      GenericState<T, D>(state: State.requestError, message: message);
  factory GenericState.serverError(String? message) => GenericState<T, D>(
      state: State.serverError, message: message ?? 'Something went wrong!');

  bool get isInitial => state == State.initial;
  bool get isLoading => state == State.loading;
  bool get isLoaded => state == State.loaded;
  bool get isRequestError => state == State.requestError;
  bool get isServerError => state == State.serverError;
}
