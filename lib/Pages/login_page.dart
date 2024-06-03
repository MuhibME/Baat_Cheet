import 'package:baat_cheet/auth/auth_service.dart';
import 'package:baat_cheet/componenets/my_button.dart';
import 'package:baat_cheet/componenets/my_text_field.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.onTap});
  //text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //page change
  final void Function()? onTap;

  void login(BuildContext context) async{
    final  authService =AuthService();

    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch (e){
      showDialog(context: context, builder:(context)=> AlertDialog(
        title:Text( e.toString(),)
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Icon
              Icon(Icons.message_rounded,size: 50, color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 50,),


              ///Message
              Text("Welcome back!", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              const SizedBox(height: 50,),


              ///Text field email
              MyTextField(text: "Email", controller:emailController ,),
              const SizedBox(height: 25,),

              ///Text field password
              MyTextField(text: "Password",obscureText: true, controller:passwordController ,),
              const SizedBox(height: 25,),

              ///button
              MyButton(text: "Login",onTap: ()=> login(context),),

              ///register
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: TextStyle(color: Theme.of(context).colorScheme.primary,)),
                  GestureDetector(onTap: onTap, child:  Text("Register Now", style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
