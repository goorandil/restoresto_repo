import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/checkout_controller.dart';
import '../controllers/profile_controller.dart';
import '../helper/global_var.dart';
import 'myaccount_page.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({Key? key}) : super(key: key);

  final CheckoutController controller = Get.put(CheckoutController());
  final String tag = 'CheckoutPage ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
        appBar: controller.buildAppBar(),
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
                    Obx(
                      () {
                        return TextFormField(
                            enabled: false,
                            controller: controller.ordertotalController,
                            //   initialValue: '${userBox.read('username')}',
                            onChanged:
                                controller.ordertotalChanged, // controller func
                            decoration: InputDecoration(
                                labelText: 'Total orders'.tr,
                                labelStyle:
                                    TextStyle(color: GlobalVar.to.primary),
                                errorText:
                                    controller.errorTextordertotal.value // obs
                                ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () {
                        return TextFormField(
                            enabled: false,
                            controller: controller.ordernameController,
                            //   initialValue: '${userBox.read('username')}',
                            onChanged:
                                controller.ordernameChanged, // controller func
                            decoration: InputDecoration(
                                labelText: 'Name'.tr,
                                labelStyle:
                                    TextStyle(color: GlobalVar.to.primary),
                                errorText:
                                    controller.errorTextordername.value // obs
                                ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () {
                        return TextFormField(
                            controller: controller.tablenumberController,
                            keyboardType: TextInputType.number,
                            onChanged: controller
                                .tablenumberChanged, // controller func
                            decoration: InputDecoration(
                                labelText: 'Table Number'.tr,
                                labelStyle:
                                    TextStyle(color: GlobalVar.to.primary),
                                errorText:
                                    controller.errorTexttablenumber.value // obs
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
                                      onPressed: controller.submitFunc.value,

                                      style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          primary: GlobalVar.to.primaryButton,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 0),
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),

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
        ));
  }
}
