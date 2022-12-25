import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helper/global_var.dart';

class MyorderController extends GetxController {
  RxString qr = ''.obs;
  RxBool camstate = false.obs;
  late String _scanBarcode = 'Unknown';
  var f = DateFormat('dd MMM yyyy hh:mm a');
  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);

  String scannedQrcode = '';

  @override
  Future<void> onInit() async {
    super.onInit();
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
          '#ff6666', 'Cancel', false, ScanMode.QR);
      print('scannedQrcode $scannedQrcode');
      if (scannedQrcode != '-1') {
        print('scannedQrcode $scannedQrcode');
      }
    } on PlatformException {
      print('scannedQrcode PlatformException');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //   if (!mounted) return;

    //  setState(() {

    //});
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

  Widget getMyorderList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return getDataMyorder(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  Widget getDataMyorder(
      AsyncSnapshot<QuerySnapshot<Object?>?> snapshot, int index) {
    return InkWell(
        onTap: () {
          // inimah buat edit

          userBox.write('editmyorderid', snapshot.data!.docs[index].id);
          userBox.write(
              'editordertotal', snapshot.data!.docs[index]['orderTotal']);
          userBox.write('editusername', snapshot.data!.docs[index]['userName']);
          userBox.write(
              'edittablenumber', snapshot.data!.docs[index]['tableNumber']);
          userBox.write(
              'editorderstatus', snapshot.data!.docs[index]['orderStatus']);
          userBox.write('editrestoid', snapshot.data!.docs[index]['restoID']);
          userBox.write(
              'editmerchantid', snapshot.data!.docs[index]['merchantID']);

          Get.toNamed('myorderdetail');
        },
        child: Card(
          color: Colors.white,
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            f.format(DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data!.docs[index]["icreatedAt"] *
                                    1000)),
                            style: TextStyle(
                                color: GlobalVar.to.colorText,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child:
                              '${snapshot.data!.docs[index]['tableNumber']}' !=
                                      'null'
                                  ? Text(
                                      'Meja : ${snapshot.data!.docs[index]['tableNumber']}',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.normal),
                                    )
                                  : Text(
                                      ' -',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data!.docs[index]['icreatedAt']}',
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
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data!.docs[index]['userName']}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data!.docs[index]['orderStatus']}' ==
                                    'request'
                                ? 'Status : ${'Request'.tr}'
                                : '${snapshot.data!.docs[index]['orderStatus']}' ==
                                        'process'
                                    ? 'Status : ${'Process'.tr}'
                                    : '${snapshot.data!.docs[index]['orderStatus']}' ==
                                            'completed'
                                        ? 'Status : ${'Completed'.tr}'
                                        : 'Status : ${'Cancel'.tr}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            //    '${snapshot.data!.docs[index]['orderTotal']}',
                            'Rp. ${saldo.format(int.parse(userBox.read('ordertotal').toString()))}',
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
        ));
  }
}
