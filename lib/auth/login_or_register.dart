import 'package:baat_cheet/Pages/login_page.dart';
import 'package:baat_cheet/Pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void togglePage(){
    setState(() {
      showLogin = !showLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLogin){
      return LoginPage(
        onTap: togglePage,
      );
    }
    else{
      return RegisterPage(
        onTap: togglePage,
      );
    }

  }
}
