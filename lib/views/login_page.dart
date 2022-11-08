import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../helper/global_var.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());

  final String tag = 'LoginPage ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: GlobalVar.to.primaryBg,
            child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Image(
                      image: AssetImage("assets/logo1024.png"), width: 250.0),
                  // FlutterLogo(size: 150),
                  SizedBox(
                    height: 10,
                  ),

                  const SizedBox(height: 50),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 35.0),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: GlobalVar.to.primaryButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        print('$tag login');
                        controller.loginWithGoogle();
                      },
                      child: Text("Login with Google".tr),
                    ),
                  ]),
                  const SizedBox(height: 10),
                ]))));
  }
}
 
              
              //      _signInButton()
           
          
       
     
    
   
 
