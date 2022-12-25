import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  final String tag = 'CheckoutPage ';
  Future<bool> _onWillPop() async {
    Get.toNamed('/shoppingcart');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<CheckoutController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
                appBar: PageAppBar(
                  title: Text('Checkout'.tr),
                  backbutton: '/shoppingcart',
                  appBar: AppBar(),
                  widgets: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Total'.tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: GlobalVar.to.primaryText,
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Rp. ${controller.saldo.format(int.parse(userBox.read('ordertotal').toString()))}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: GlobalVar.to.colorText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Name'.tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: GlobalVar.to.primaryText,
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${userBox.read('username')}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: GlobalVar.to.colorText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () {
                                return TextFormField(
                                    controller:
                                        controller.tablenumberController,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: false, decimal: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9\u0660-\u0669]")),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^0+')),
                                    ],
                                    onChanged: controller
                                        .tablenumberChanged, // controller func
                                    decoration: InputDecoration(
                                        hintText:
                                            "Kalau tidak ada, biarkan kosong",
                                        hintStyle: TextStyle(fontSize: 14),
                                        labelText: 'Table Number'.tr,
                                        labelStyle: TextStyle(
                                            color: GlobalVar.to.primary),
                                        errorText: controller
                                            .errorTexttablenumber.value // obs
                                        ));
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                              color: Colors.grey[100],
                              margin: const EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed:
                                                  controller.submitFunc.value,

                                              style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  primary: GlobalVar
                                                      .to.primaryButton,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 0),
                                                  textStyle: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),

                                              child: Text('next'.tr),
                                              // obs
                                            )),
                                      )),
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
