import 'package:get/get.dart';

import '../controllers/myorderhis_controller.dart';

class MyorderhisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyorderhisController());
  }
}
