import 'package:get/get.dart';

import '../controllers/myorder_detail_controller.dart';

class MyorderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyorderDetailController());
  }
}
