import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/database/myorder_db.dart';

import '../controllers/myorder_detail_controller.dart';
import 'myorder_page.dart';

class MyorderDetailPage extends StatelessWidget {
  MyorderDetailPage({Key? key}) : super(key: key);

  final MyorderDetailController controller = Get.put(MyorderDetailController());
  final String tag = 'MyorderDetailPage ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

//resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.off(() => MyorderPage());
                },
              );
            },
          ),
          centerTitle: true,
          title: Text(controller.pageTitle.value),
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
                            child: Center(child: CircularProgressIndicator())));
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
        ));
  }
}