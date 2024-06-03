import 'package:baat_cheet/auth/auth_service.dart';
import 'package:baat_cheet/componenets/my_drawer.dart';
import 'package:baat_cheet/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

import '../componenets/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  ///chat and auth services
  final chatService = ChatServices();
  final authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer:const  MyDrawer(),

      body: buildUserList(),
    );
  }

  Widget buildUserList(){
    return StreamBuilder(stream: chatService.getUsersStream(),
        builder: (context, snapshot) {
          //check errors
          if(snapshot.hasError){
            return const Text("Error");
          }

          //loading...
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: const Text("Loading..."));
          }

          //return List view
          return ListView(
            children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context),).toList(),
          );

        },
    );
  }

  //building individual user
  Widget _buildUserListItem(Map<String,dynamic> userData, BuildContext context){
    //display all users instead of current user
    if(userData['email'] != authService.getCurrentUser()!.email){
      return UserTile(
        text: userData["email"],
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiverEmail: userData["email"],receiverId: userData["uid"],),));
        },);

      }
    else{
      return Container();
    }
  }
}
