import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/database/main_db.dart';
import 'package:restoresto_repo/helper/firebase_auth_constants.dart';

import '../controllers/resto_controller.dart';
import '../database/resto_db.dart';
import '../helper/global_var.dart';
import 'addresto_page.dart';
import 'main_page.dart';

class RestoPage extends StatelessWidget {
  RestoPage({Key? key}) : super(key: key);

  final RestoController controller = Get.put(RestoController());
  final String tag = 'RestoPage ';

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
                  MainDb.getResto(firebaseAuth.currentUser!.uid);
                  Get.off(() => MainPage());
                },
              );
            },
          ),
          centerTitle: true,
          title: Text('Choose Restaurant'.tr),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: Text('scan qr code'.tr),
                    onPressed: () {
                      controller.scanQR();
                      // Get.to(() => AddrestoPage());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        primary: GlobalVar.to.primaryButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  )),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: RestoDb.getResto(),
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
                      child: Text('no resto2'.tr),
                    );
                  }
                  return controller.getRestoList(snapshot);
                  //  return Container();
                  //   return Friend(snapshot);
                },
              )),
            ],
          ),
        ));
  }
}
