import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/resto_db.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import 'package:camera/camera.dart';

import '../utils/dynamic_link_service.dart';

class RestoController extends GetxController {
  RxString qr = ''.obs;
  RxBool camstate = false.obs;
  late String _scanBarcode = 'Unknown';

  String scannedQrcode = '';

  @override
  Future<void> onInit() async {
    super.onInit();
    //   DynamicLinkService.createDynamicLink(
    //     'JV5IT3If9HBTfQ3mWepI', 'CoXBb4XppBqyVkXlMsO3');
    //  DynamicLinkService.createDynamicLink(
    //    '${userBox.read('restoid')}', '${userBox.read('merchantid')}');
  }

  bool hasCameraPermission = false;
  var cameraPermissionStatus = false;

  Future<void> requestCameraPermission() async {
    final serviceStatus = await Permission.camera.isGranted;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();
    print('requestCameraPermission');

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print('_getStoragePermission');
    }
  }

  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.status;
    final status2 = await Permission.storage.status;
    print('checkCameraPermission');
    print('checkCameraPermission status $status');
    print('checkCameraPermission status2 $status2');

    _getStoragePermission();

    if (status == PermissionStatus.granted) {
      print('checkCameraPermission isGranted');
      hasCameraPermission = true;
      update(); // only needed if you're using GetBuilder widget
      return; // ending the function here because that's all you need.
    } else if (status == PermissionStatus.denied) {
      print('checkCameraPermission isDenied');
      await Permission.camera.request();
    } else {
      print('checkCameraPermission else');
      await openAppSettings();
    }
    // ...continue to handle all the possible outcomes
    update();
  }

  var selectedImagePath = ''.obs;
  var extractedBarcode = ''.obs;

  ///get image method
  getImage(ImageSource imageSource) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      Get.snackbar("Error", "image is not selected",
          backgroundColor: Colors.red);
    }
  }

/*
  qrCallback(String code) {
    camstate.value = false;
    print('qrCallback camstate.value ${camstate.value}');
    print('qrCallback code $code');
  }

  scanCode() {
    checkCameraPermission();
    camstate.value = !camstate.value;
    print('scanCode camstate.value ${camstate.value}');
  }
*/
  Future<void> scanQR() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      scannedQrcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel'.tr, false, ScanMode.QR);
      print('scannedQrcode 1 $scannedQrcode');
      if (scannedQrcode != '-1') {
        print('scannedQrcode 2 $scannedQrcode');

        Get.defaultDialog(
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.all(15),
          title: 'Bergabung dengan resto?'.tr,
          content: Text('Select'.tr),
          //  backgroundColor: Colors.teal,

          radius: 30,
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: GlobalVar.to.primaryText),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Continue'.tr,
                style: TextStyle(color: GlobalVar.to.primaryText),
              ),
              onPressed: () {
                Get.back();
                launchURLtoc('$scannedQrcode');
              },
            ),
          ],
        );
      }
    } on PlatformException {
      print('scannedQrcode 3 PlatformException');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //   if (!mounted) return;

    //  setState(() {

    //});
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  launchURLtoc(String urlstr) async {
    String merchanturl = urlstr;
    var arr = merchanturl.split('/');
    print('launchURLtoc $merchanturl');
    print('launchURLtoc $arr');
    print('launchURLtoc ${arr[2]}');
    print('launchURLtoc ${arr[3]}');
    Uri url =
        Uri(scheme: 'https', host: 'restoresto.page.link', path: '${arr[3]}');
    _launchInBrowser(url);
    if (await canLaunchUrl(url)) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel'.tr, true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //  if (!mounted) return;

    //setState(() {
    _scanBarcode = barcodeScanRes;

    ///});
  }

  ///recognise image text method
  Future<void> recognizedText(String pickedImage) async {
    checkCameraPermission();
    if (pickedImage == null) {
      print('recognizedText $pickedImage');
      Get.snackbar("Error", "image is not selected",
          backgroundColor: Colors.red);
    } else {
      print('recognizedText else ${pickedImage.toString()}');
      extractedBarcode.value = '';
      /*  var barCodeScanner = GoogleMlKit.vision.barcodeScanner();
      print('recognizedText ${barCodeScanner.toString()}');
      final visionImage = InputImage.fromFilePath(pickedImage);
      print('recognizedText ${visionImage.toString()}');
      try {
        var barcodeText = await barCodeScanner.processImage(visionImage);

        for (Barcode barcode in barcodeText) {
          extractedBarcode.value = barcode.displayValue!;
        }
      } catch (e) {
        Get.snackbar("Errorx", e.toString(), backgroundColor: Colors.white);
        print(e.toString());
      }
    */
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Widget getMymerchantList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot2) {
    print('$tag getMymerchantList ');
    if (snapshot2.hasData) {
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, i) {
            return StreamBuilder<DocumentSnapshot>(
                stream: _mymerchantStream(snapshot2.data!.docs[i].id),
                builder: (context, snapshot) {
                  print(' snapshot.hasData ' + snapshot.hasData.toString());

                  return InkWell(
                      onTap: () {
                        // inimah buat edit
                        userBox.write('editmerchantid', snapshot.data!.id);
                        // inimah buat paket

                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(15),
                          contentPadding: const EdgeInsets.all(15),
                          title: 'what will you do?'.tr,
                          content: Text('Select'.tr),
                          //  backgroundColor: Colors.teal,

                          radius: 30,
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Select'.tr,
                                style:
                                    TextStyle(color: GlobalVar.to.primaryText),
                              ),
                              onPressed: () {
                                //yg merchantidx dibadingkan dulu
                                // barangkali masih ada dari merchnat id
                                // lain, karena mau resrt shopcart
                                GlobalVar.to.merchantnamex.value =
                                    snapshot.data!['merchantName'];
                                GlobalVar.to.merchantaddressx.value =
                                    snapshot.data!['merchantAddress'];
                                GlobalVar.to.merchantimageurlx.value =
                                    snapshot.data!['merchantImageurl'];
                                RestoDb.takeMymerchant();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Delete'.tr,
                                style:
                                    TextStyle(color: GlobalVar.to.primaryText),
                              ),
                              onPressed: () {
                                RestoDb.deleteMymerchant(snapshot.data!.id);
                              },
                            ),
                          ],
                        );
                      },
                      child: snapshot.hasData
                          ? Card(
                              color: GlobalVar.to.primaryCard,
                              elevation: 5,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              '${snapshot.data!.get('merchantImageurl')}',
                                              width: 45.0,
                                              fit: BoxFit.fitWidth,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          })),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot.data!.get(
                                                                'merchantName') ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot.data!.get(
                                                                'merchantAddress') ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${snapshot.data!.get('merchantPhone')}',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ])),
                                  ],
                                ),
                              ),
                            )
                          : Text('Loading ...'.tr));
                });

            //  return getDataResto(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  _mymerchantStream(String id) {
    print('_applicationStream $id');
    return firebaseFirestore.collection('merchants').doc(id).snapshots();
  }
}
