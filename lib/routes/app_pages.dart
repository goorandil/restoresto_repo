import 'package:get/get.dart';

import '../binding/checkout_binding.dart';
import '../binding/login_binding.dart';
import '../binding/main_binding.dart';
import '../binding/myaccount_binding.dart';
import '../binding/profile_binding.dart';
import '../binding/resto_binding.dart';
import '../binding/shopping_cart_binding.dart';
import '../views/checkout_page.dart';
import '../views/login_page.dart';
import '../views/main_page.dart';
import '../views/myaccount_page.dart';
import '../views/profile_page.dart';
import '../views/resto_page.dart';
import '../views/shopping_cart_page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.myaccount,
      page: () => const MyaccountPage(),
      binding: MyaccountBinding(),
    ),
    GetPage(
      name: AppRoutes.resto,
      page: () => const RestoPage(),
      binding: RestoBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.shoppingcart,
      page: () => const ShoppingCartPage(),
      binding: ShoppingCartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: CheckoutBinding(),
    ),
  ];
}
