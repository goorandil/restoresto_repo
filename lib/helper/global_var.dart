import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final userBox = GetStorage();
final packageBox = GetStorage();
final orderBox = GetStorage();
final topupBox = GetStorage();

class GlobalVar extends GetxController {
  static GlobalVar get to => Get.find<GlobalVar>();
  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);

  final saldo0 = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', decimalDigits: 0);
  final saldo1 = NumberFormat.currency(
      locale: 'en_US', customPattern: '#,###', decimalDigits: 0);
  final saldo2 = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###.0#', decimalDigits: 0);
  final saldo3 = NumberFormat.currency(
      locale: 'en_US', customPattern: '###.0#', decimalDigits: 0);

  RxList shopcartList = [].obs;

  RxInt currencyFormat = 0.obs;
  RxString currencySymbol = "".obs;
  RxString useridx = "".obs;
  RxString usernamex = "".obs;
  RxString useremailx = "".obs;
  RxString userimageurlx = "".obs;
  RxString userfcmtokenx = "".obs;

  RxString merchantidx = "".obs;
  RxString merchantnamex = "".obs;
  RxString merchantimageurlx = "".obs;
  RxString merchantaddressx = "".obs;
  RxString merchantfcmtokenx = "".obs;

  RxList categorylistx = [].obs;

  RxString eventidx = "".obs;
  RxString eventnamex = "".obs;
  RxString eventdescriptionx = "".obs;
  RxString eventcodex = "".obs;
  RxString deeplinkx = "".obs;
  RxString ungueslinkx = "".obs;
  RxString getdeeplinkx = "".obs;
  RxString getungueslinkx = "".obs;
  RxString teacheridx = "".obs;

  RxString configidx = "ckhRNRMdrjGppnNY54aI".obs;
  RxString kecilx = "10000".obs;
  RxString sedangx = "15000".obs;
  RxString besarx = "20000".obs;
  RxInt totalx = 0.obs;

  RxString tarifkotabandungkecilx = "".obs;
  RxString tarifkotabandungsedangx = "".obs;
  RxString tarifkotabandungbesarx = "".obs;
  RxString tarifkotacimahikecilx = "".obs;
  RxString tarifkotacimahisedangx = "".obs;
  RxString tarifkotacimahibesarx = "".obs;
  RxString tarifkabbandungkecilx = "".obs;
  RxString tarifkabbandungsedangx = "".obs;
  RxString tarifkabbandungbesarx = "".obs;
  RxString tarifkabbandungbaratkecilx = "".obs;
  RxString tarifkabbandungbaratsedangx = "".obs;
  RxString tarifkabbandungbaratbesarx = "".obs;

  RxString banknamex = "BRI".obs;
  RxString accountnamex = "Kurirku".obs;
  RxString accountnumberx = "123123123123".obs;

  var primary = Color.fromARGB(255, 4, 132, 168);
  var primaryButton = Colors.red;
  var primaryText = Colors.black;
  var colorText = Color.fromARGB(255, 4, 132, 168);
  var primaryBg = Colors.grey[100];
  var primaryCard = Colors.white;
}
