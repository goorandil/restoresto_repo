import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/global_var.dart';

class MyorderhisDetailController extends GetxController {
  RxString pageTitle = 'Order Details'.tr.obs;
  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
  }

  Widget getMyorderDetailList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return getDataMyorderDetail(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  Widget getDataMyorderDetail(
      AsyncSnapshot<QuerySnapshot<Object?>?> snapshot, int index) {
    return InkWell(
        onTap: () {},
        child: Card(
            color: Colors.white,
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: snapshot.data!.size != 0
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                  '${snapshot.data!.docs[index]['menuImageurl']}',
                                  width: 45.0,
                                  fit: BoxFit.fitWidth, loadingBuilder:
                                      (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }))
                          : Text('Loading ...'.tr),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${snapshot.data!.docs[index]['menuName']}',
                                      style: TextStyle(
                                          color: GlobalVar.to.colorText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${snapshot.data!.docs[index]['menuDescription']}',
                                      style: TextStyle(
                                          color: GlobalVar.to.primaryText,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      //  '${snapshot.data!.docs[index]['menuPrice']}',
                                      'Rp. ${saldo.format(int.parse(snapshot.data!.docs[index]['menuPrice'].toString()))}',
                                      style: TextStyle(
                                          color: GlobalVar.to.colorText,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${'Qty'.tr} : ${snapshot.data!.docs[index]['qty']}',
                                      style: TextStyle(
                                          color: GlobalVar.to.primaryText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      //   '${snapshot.data!.docs[index]['sumtot']}',
                                      'Rp. ${saldo.format(int.parse(snapshot.data!.docs[index]['sumtot'].toString()))}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: GlobalVar.to.colorText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ]),
            )));
  }
}
