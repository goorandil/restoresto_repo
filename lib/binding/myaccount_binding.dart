import 'package:get/get.dart';

import '../controllers/myaccount_controller.dart';

class MyaccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyaccountController());
  }
}
