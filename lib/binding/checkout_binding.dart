import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';
import '../controllers/shopping_cart_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
  }
}
