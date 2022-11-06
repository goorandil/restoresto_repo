import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';
import '../controllers/myaccount_controller.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';
import 'main_page.dart';
import 'profile_page.dart';

class MyaccountPage extends StatelessWidget {
  const MyaccountPage({Key? key}) : super(key: key);

  final String tag = 'MyaccountPage ';

  Future<bool> _onWillPop() async {
    Get.toNamed('/main');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MyaccountController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,
                resizeToAvoidBottomInset: false,
//resizeToAvoidBottomPadding: false,
                appBar: PageAppBar(
                  title: Text('My Account'.tr),
                  backbutton: '/main',
                  appBar: AppBar(),
                  widgets: const <Widget>[
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
                body: ListView(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(25),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'My Profile'.tr,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  const Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: InkWell(
                      onTap: () {
                        //    fiam.triggerEvent('bagikan_event');
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        Share.share(controller.shareApp.value,
                            subject: controller.pageTitle.value,
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      }, // Update the state of the app.

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Share App'.tr,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: InkWell(
                      onTap: () {
                        controller.launchURLtoc();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Terms and conditions'.tr,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: InkWell(
                      onTap: () {
                        controller.launchURLpriv();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Privacy Policy'.tr,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: InkWell(
                      onTap: () {
                        controller.exitApp(context);
                      }, // Update the state of the app.

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Logout'.tr,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Obx(() => Text(
                              '${controller.appVersion.value}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.left,
                            )),
                      ],
                    ),
                  ),
                ]))));
  }
}
