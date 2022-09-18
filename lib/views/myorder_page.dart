import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/database/main_db.dart';
import 'package:restoresto_repo/helper/firebase_auth_constants.dart';
import 'package:restoresto_repo/views/myorderhis_page.dart';

import '../controllers/myorder_controller.dart';
import '../controllers/resto_controller.dart';
import '../database/myorder_db.dart';
import '../database/resto_db.dart';
import '../helper/global_var.dart';
import 'addresto_page.dart';
import 'main_page.dart';

class MyorderPage extends StatelessWidget {
  MyorderPage({Key? key}) : super(key: key);

  final MyorderController controller = Get.put(MyorderController());
  final String tag = 'MyorderPage ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: GlobalVar.to.primary,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.off(() => MainPage());
                },
              );
            },
          ),
          centerTitle: true,
          title: Text('My Order'.tr),
          actions: [
            TextButton(
              child: Text(
                'History'.tr,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              style: TextButton.styleFrom(fixedSize: Size.fromHeight(150)),
              onPressed: () {
                Get.to(() => MyorderhisPage());
              },
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
                            child: Center(child: CircularProgressIndicator())));
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
        ));
  }
}
