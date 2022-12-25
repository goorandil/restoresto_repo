import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/myorder_controller.dart';
import '../database/myorder_db.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';

class MyorderPage extends StatelessWidget {
  const MyorderPage({Key? key}) : super(key: key);
  final String tag = 'MyorderPage ';

  Future<bool> _onWillPop() async {
    Get.toNamed('/main');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MyorderController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
                appBar: PageAppBar(
                  title: Text('My Order'.tr),
                  backbutton: '/main',
                  appBar: AppBar(),
                  widgets: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.history,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.toNamed('myorderhis');
                        //     EasyLoading.show(status: 'loading...');
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                        stream: MyorderDb.getMyorder(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot?> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.data == null) {
                            return const Center(
                                child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: CircularProgressIndicator())));
                          }

                          if (snapshot.data!.size == 0) {
                            return Container(
                              padding: const EdgeInsets.all(30),
                              child: Text('No order data yet'.tr),
                            );
                          }
                          return controller.getMyorderList(snapshot);
                          //  return Container();
                          //   return Friend(snapshot);
                        },
                      )),
                    ],
                  ),
                ))));
  }
}
