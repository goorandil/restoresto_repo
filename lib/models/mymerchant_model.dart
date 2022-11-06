import 'package:cloud_firestore/cloud_firestore.dart';

class MymerchantModel {
  String? documentId;
  late String menuName;
  late String menuImageurl;
  late String menuDescription;
  late String menuPrice;
  late bool menuStatus;
  late Timestamp createdAt;
  late String menuCategoryName;
  late String menuCategoryId;
  // late bool isDone;

  MymerchantModel({
    required this.menuName,
    required this.menuImageurl,
    required this.menuDescription,
    required this.menuPrice,
    required this.menuStatus,
    required this.createdAt,
    required this.menuCategoryName,
    required this.menuCategoryId,
    //   required this.isDone,
//     required this.createdOn,
  });

  MymerchantModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    menuName = documentSnapshot["menuName"];
    menuImageurl = documentSnapshot["menuImageurl"];
    menuDescription = documentSnapshot["menuDescription"];
    menuPrice = documentSnapshot["menuPrice"];
    menuStatus = documentSnapshot["menuStatus"];
    createdAt = documentSnapshot["createdAt"];
    menuCategoryName = documentSnapshot["menuCategoryName"];
    menuCategoryId = documentSnapshot["menuCategoryID"];
    //   isDone = documentSnapshot["isDone"];
  }
}
