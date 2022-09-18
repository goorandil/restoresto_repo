import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:restoresto_repo/controllers/myaccount_controller.dart';

import '../database/profile_db.dart';
import '../helper/global_var.dart';
import '../views/myaccount_page.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  RxString pageTitle = 'Profil Saya'.obs;
  RxString saveData = 'Simpan'.obs;
  RxString changeData = 'Ubah'.obs;

  RxString userid = ''.obs;

  RxString username = RxString('');
  RxString useremail = RxString('');
  RxString userphone = RxString('');
  RxString useraddress = RxString('');
  RxString userimageurl = RxString('');

  TextEditingController usernameController = TextEditingController();
  TextEditingController useremailController = TextEditingController();
  TextEditingController userphoneController = TextEditingController();
  TextEditingController useraddressController = TextEditingController();

  RxnString errorTextusername = RxnString(null);
  RxnString errorTextuseremail = RxnString(null);
  RxnString errorTextuserphone = RxnString(null);
  RxnString errorTextuseraddress = RxnString(null);

  Rxn<Function()> submitFunc = Rxn<Function()>(null);

  File? imageFile;
  final picker = ImagePicker();
  File? pickedImageFile;

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 20);

    imageFile = File(pickedFile!.path);
    update();
  }

  void _pickImagecamera() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 20);

    // imageFile = File(pickedFile!.path);
    imageFile = File(pickedFile!.path);

    update();
  }

  getImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: image.path,
        maxHeight: 200,
        maxWidth: 200,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: GlobalVar.to.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      imageFile = File(croppedFile!.path);
      update();
    }
  }

  void Function() get pickImage => _pickImage;
  void Function() get pickImagecamera => _pickImagecamera;

  Future uploadImageToFirebase() async {
    print('uploadImageToFirebase userid ${userBox.read('userid')}');
    print('uploadImageToFirebase imageFile $imageFile');
    print('uploadImageToFirebase imageFile.path ${imageFile?.path}');
    String fileName = basename(imageFile!.path);
    print('uploadImageToFirebase fileName $fileName');
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('userImageurl/$fileName');
    UploadTask? uploadTask = firebaseStorageRef.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref
        .getDownloadURL()
        .then((value) => ProfileDb.updateProfile(value));
    print('a $imageFile');
    imageFile = null;
    print('b $imageFile');
    MyaccountController.to.getUserData();
    //   taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    //   );

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');

      switch (snapshot.state) {
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.running:
          showIndi();

          break;
        case TaskState.success:
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    }, onError: (e) {
      // The final snapshot is also available on the status via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(uploadTask.snapshot);
    });
  }

  Future<File> fileFromImageUrl(Uri imageurl) async {
    final response = await http.get(imageurl);

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  @override
  void onInit() {
    super.onInit();

    submitFunc.value = submitFunction();
    debounce<String>(username, validations,
        time: const Duration(milliseconds: 500));

    //  debounce<String>(userphone, validations,
    //       time: const Duration(milliseconds: 500));
    //   debounce<String>(useraddress, validations,
//        time: const Duration(milliseconds: 500));
    print('onInit email ${userBox.read('useremail')}');

    useremailController.text = '${userBox.read('useremail')}';
    usernameController.text = userBox.read('username');
    useraddressController.text = userBox.read('useraddress');
    userphoneController.text = '${userBox.read('userphone')}';
  }

  void validations(String val) async {
    errorTextusername.value = null; // reset validation errors to nothing
    if (val.isNotEmpty) {
      if (lengthOK(val) && await available(val)) {
        print('All validations passed, enable submit btn...');
        submitFunc.value = submitFunction();
        errorTextusername.value = null;
      } else {
        submitFunc.value = null;
      }
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: GlobalVar.to.primary,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.off(() => MyaccountPage());
            },
          );
        },
      ),
      centerTitle: true,
      title: Text(pageTitle.value),
    );
  }

  bool lengthOK(String val, {int minLen = 5}) {
    if (val.length < minLen) {
      errorTextusername.value = 'min. 5 chars';
      return false;
    }
    return true;
  }

  Future<bool> available(String val) async {
    print('Query availability of: $val');
    await Future.delayed(
        const Duration(seconds: 1), () => print('Available query returned'));

    if (val == "Sylvester") {
      errorTextusername.value = 'Name Taken';
      return false;
    }
    return true;
  }

  void usernameChanged(String val) {
    userBox.write('username', val);
    username.value = val;
  }

  void userphoneChanged(String val) {
    userBox.write('userphone', val);
    userphone.value = val;
  }

  void useraddressChanged(String val) {
    userBox.write('useraddress', val);
    useraddress.value = val;
  }

  void useremailChanged(String val) {
    //    useremail.value = val;
  }

  Future<bool> Function() submitFunction() {
    return () async {
      print(
          'Make database call to create ${username.value} ${userBox.read('userid')} account');
      if (imageFile != null)
        uploadImageToFirebase();
      else
        ProfileDb.updateProfile('');
      //   DisplayAlertDialog.okButton('Notifikasi', 'Profil sudah diubah');
      await Future.delayed(const Duration(seconds: 1), () => showIndi());
      return true;
    };
  }

  showIndi() {
    return SizedBox(
        width: 30,
        height: 30,
        child: Center(child: CircularProgressIndicator()));
  }
}
