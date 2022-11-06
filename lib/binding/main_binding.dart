import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
