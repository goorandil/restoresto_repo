import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/resto_controller.dart';
import '../helper/global_var.dart';
import 'resto_page.dart';

class AddrestoPage extends StatelessWidget {
  AddrestoPage({Key? key}) : super(key: key);

  final RestoController controller = Get.put(RestoController());
  final String tag = 'AddrestoPage ';

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
                Get.off(() => RestoPage());
              },
            );
          },
        ),
        centerTitle: true,
        title: Text('Choose Restaurant'.tr),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 220,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child:

                    ///image box scrollview
                    SingleChildScrollView(
                  child: Obx(
                    () => controller.selectedImagePath.value == ''
                        ? Center(
                            child: Text(
                                "Select an image from Gallery / camera".tr))
                        : Image.file(
                            File(controller.selectedImagePath.value),
                            width: Get.width,
                            height: 300,
                          ),
                  ),
                )),

            ///button row
            Container(
              //margin: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        controller.getImage(ImageSource.gallery);
                      },
                      child: const Text("Pick Image")),
                  ElevatedButton(
                      onPressed: () {
                        controller
                            .recognizedText(controller.selectedImagePath.value);
                      },
                      child: const Text("Extract Text")),
                ],
              ),
            ),

            ///text box ScrollView
            SingleChildScrollView(
              child: Container(
                height: 100,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Obx(() => controller.extractedBarcode.value.isEmpty
                    ? const Center(child: Text("Text Not Found"))
                    : Center(child: Text(controller.extractedBarcode.value))),
              ),
            )
            /*    Obx(
              () => controller.camstate.value == true
                  ? new SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: new QrCamera(
                        qrCodeCallback: (code) {
                          print('aaaaaaaaaaaaaaaaaaaaaaa $code');
                          controller.qrCallback(code!);
                        },
                      ),

                      ///image box container
                      /*      Container(
                height: 420,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child:

                    ///image box scrollview
                    SingleChildScrollView(
                  child: Obx(
                    () => controller.selectedImagePath.value == ''
                        ? const Center(
                            child:
                                Text("Select an image from Gallery / camera"))
                        : Image.file(
                            File(controller.selectedImagePath.value),
                            width: Get.width,
                            height: 400,
                          ),
                  ),
                )),

            ///button row
            Container(
              //margin: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        controller.getImage(ImageSource.gallery);
                      },
                      child: const Text("Pick Image")),
                  ElevatedButton(
                      onPressed: () {
                        controller.checkCameraPermission();
                        controller
                            .recognizedText(controller.selectedImagePath.value);
                      },
                      child: const Text("Scan")),
                ],
              ),
            ),

            ///text box ScrollView
            SingleChildScrollView(
              child: Container(
                height: 90,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Obx(() => controller.extractedBarcode.value.isEmpty
                    ? const Center(child: Text("No data found in barcode"))
                    : Center(child: Text(controller.extractedBarcode.value))),
              ), */
                    )
                  : Center(
                      child: Text('Scan a Code'),
                    ),
            )
      */
          ],
        ),
      )),
      /*    floatingActionButton: Visibility(
        visible: !controller.camstate.value,
        child: FloatingActionButton(
          onPressed: controller.scanCode,
          tooltip: 'Scan',
          child: Icon(Icons.scanner),
        ),
      ),*/
    );
  }
}
