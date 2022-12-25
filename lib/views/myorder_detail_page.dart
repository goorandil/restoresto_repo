import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/database/myorder_db.dart';

import '../controllers/myorder_detail_controller.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';

class MyorderDetailPage extends StatelessWidget {
  const MyorderDetailPage({Key? key}) : super(key: key);

  final String tag = 'MyorderDetailPage ';

  Future<bool> _onWillPop() async {
    Get.toNamed('/myorder');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MyorderDetailController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
                appBar: PageAppBar(
                  title: Text('My Order Detail'.tr),
                  backbutton: '/myorder',
                  appBar: AppBar(),
                  widgets: <Widget>[],
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
                        stream: MyorderDb.getMyorderDetail(),
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
                              child: Text('No order data ye'.tr),
                            );
                          }
                          return controller.getMyorderDetailList(snapshot);
                          //    return Container();
                          //   return Friend(snapshot);
                        },
                      )),
                    ],
                  ),
                ))));
  }
}
