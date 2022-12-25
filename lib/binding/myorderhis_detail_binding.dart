import 'package:get/get.dart';

import '../controllers/myorderhis_detail_controller.dart';

class MyorderhisDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyorderhisDetailController());
  }
}
