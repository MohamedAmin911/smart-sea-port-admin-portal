import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController {
  final String _userName = 'admin';
  final String _password = 'admin';
  bool checkUserNameAndPassword(String userName, String password) {
    if (userName == _userName && password == _password) {
      return true;
    } else {
      return false;
    }
  }
}
