import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global_var.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final String backbutton;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const PageAppBar(
      {Key? key,
      required this.title,
      required this.backbutton,
      required this.appBar,
      required this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: GlobalVar.to.primary,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GlobalVar.to.merchantnamex.value = '';
              GlobalVar.to.merchantaddressx.value = '';
              GlobalVar.to.merchantimageurlx.value = '';
              userBox.remove('sumtot');
              Get.toNamed(backbutton);
            });
      }),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
