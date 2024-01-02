abstract class BaseBloc {
  void onInit() {
    print("<<<<<<<< init state");
  }

  void onDispose() {
    print("dispose state >>>>>>>>>>>");
  }

  Stream get mainStream;
}
