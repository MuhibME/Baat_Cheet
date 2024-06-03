import 'package:baat_cheet/auth/auth_service.dart';
import 'package:baat_cheet/componenets/my_button.dart';
import 'package:baat_cheet/componenets/my_text_field.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, this.onTap});
  //text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final void Function()? onTap;


  void register(BuildContext context)async{
    final authService = AuthService();
    if(passwordController.text == confirmController.text){
    try{
      await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(title: Text(e.toString()),),);
    }
    }
    else{
      showDialog(context: context, builder: (context) => const  AlertDialog(title: Text("password does not match"),),);
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
            children: [
              ///Icon
              Icon(Icons.message_rounded,size: 50, color:Theme.of(context).colorScheme.primary ,),
              const SizedBox(height: 50,),


              ///Message
              Text("Create an account", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              const SizedBox(height: 50,),


              ///Text field email
              MyTextField(text: "Email", controller:emailController ,),
              const SizedBox(height: 25,),

              ///Text field password
              MyTextField(text: "Password",obscureText: true, controller:passwordController ,),
              const SizedBox(height: 25,),

              ///confirm password
              MyTextField(text: "Password",obscureText: true, controller:confirmController ,),
              const SizedBox(height: 25,),
              ///button
              MyButton(text: 'Register', onTap:()=> register(context),),


              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",style: TextStyle(color: Theme.of(context).colorScheme.primary,)),
                  GestureDetector(onTap: onTap, child:  Text("login Now", style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
