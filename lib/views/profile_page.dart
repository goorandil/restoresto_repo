import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_controller.dart';
import '../helper/global_var.dart';
import 'myaccount_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());
  final String tag = 'ProfilePage ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.to.primaryBg,

//resizeToAvoidBottomPadding: false,
      appBar: controller.buildAppBar(),
      body: ListView(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetBuilder<ProfileController>(builder: (logic) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (logic.imageFile != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  logic.imageFile as File,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.fitWidth,
                                ))
                            : '${userBox.read('userimageurl')}' != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                        '${userBox.read('userimageurl')}',
                                        width: 200.0,
                                        fit: BoxFit.fitWidth,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }))
                                : Container(),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TextButton.icon(
                            onPressed: (() {
                              controller.getImage(ImageSource.gallery);
                            }),
                            icon:
                                Icon(Icons.image, color: GlobalVar.to.primary),
                            label: Text(
                              'Dari Galeri',
                              style: TextStyle(
                                  fontSize: 18, color: GlobalVar.to.primary),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: TextButton.icon(
                            onPressed: (() {
                              controller.getImage(ImageSource.camera);
                            }),
                            icon:
                                Icon(Icons.camera, color: GlobalVar.to.primary),
                            label: Text(
                              'Dari Kamera',
                              style: TextStyle(
                                  fontSize: 18, color: GlobalVar.to.primary),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      return TextFormField(
                          enabled: false,
                          controller: controller.useremailController,
                          //   initialValue: '${userBox.read('username')}',
                          onChanged:
                              controller.useremailChanged, // controller func
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle:
                                  TextStyle(color: GlobalVar.to.primary),
                              errorText:
                                  controller.errorTextuseremail.value // obs
                              ));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      return TextFormField(
                          controller: controller.usernameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          // initialValue: '${controller.usernamex.value}',
                          onChanged:
                              controller.usernameChanged, // controller func
                          decoration: InputDecoration(
                              labelText: 'Nama',
                              labelStyle:
                                  TextStyle(color: GlobalVar.to.primary),
                              errorText:
                                  controller.errorTextusername.value // obs
                              ));
                    },
                  ),
                  Obx(
                    () {
                      return TextFormField(
                          controller: controller.userphoneController,
                          // initialValue: '${controller.userphonex.value}',
                          keyboardType: TextInputType.phone,
                          onChanged:
                              controller.userphoneChanged, // controller func
                          decoration: InputDecoration(
                              labelText: 'Telepon',
                              labelStyle:
                                  TextStyle(color: GlobalVar.to.primary),
                              errorText:
                                  controller.errorTextusername.value // obs
                              ));
                    },
                  ),
                  Obx(
                    () {
                      return TextFormField(
                          controller: controller.useraddressController,
                          //   initialValue: '${controller.useraddressx.value}',
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.words,
                          maxLines: 2,
                          onChanged:
                              controller.useraddressChanged, // controller func
                          decoration: InputDecoration(
                              labelText: 'Alamat',
                              labelStyle:
                                  TextStyle(color: GlobalVar.to.primary),
                              errorText:
                                  controller.errorTextuseraddress.value // obs
                              ));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => Container(
                        alignment: AlignmentDirectional.topEnd,
                        child: ElevatedButton(
                          onPressed: controller.submitFunc.value,
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

                          child: Text(controller.changeData.value), // obs
                        ),
                      ))
                ],
              ),
            )
          ]),
    );
  }
}
