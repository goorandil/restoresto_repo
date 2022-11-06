import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/myaccount_controller.dart';
import '../controllers/profile_controller.dart';

class MyaccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyaccountController());
  }
}
