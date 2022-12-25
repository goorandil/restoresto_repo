import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/database/myorder_db.dart';

import '../controllers/myorderhis_detail_controller.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';
import 'myorderhis_page.dart';

class MyorderhisDetailPage extends StatelessWidget {
  const MyorderhisDetailPage({Key? key}) : super(key: key);

  final String tag = 'MyorderhisDetailPage ';

  Future<bool> _onWillPop() async {
    Get.toNamed('/myorderhis');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MyorderhisDetailController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,
//resizeToAvoidBottomPadding: false,
                appBar: PageAppBar(
                  title: Text('History Detail'.tr),
                  backbutton: '/myorderhis',
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
                              child: Text('No order data yet'.tr),
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
