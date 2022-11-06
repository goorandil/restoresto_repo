import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/profile_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
