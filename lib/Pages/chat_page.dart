import 'package:baat_cheet/auth/auth_service.dart';
import 'package:baat_cheet/componenets/chat_bubble.dart';
import 'package:baat_cheet/componenets/my_text_field.dart';
import 'package:baat_cheet/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  final String receiverEmail;
  final String receiverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  ///chat and auth services
  final chatService = ChatServices();

  final authService = AuthService();

  ///send message
  void sendMessage() async {
    //if there is something inside textfield send message
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();

    }
    scrollDown();
  }

  //text field focus
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///add listener to focus node
    myFocusNode.addListener((){
      if (myFocusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 250), ()=> scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 250), ()=> scrollDown());
  }
  @override void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

//scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade500,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display All messages
          Expanded(child: _buildMessageList()),

          //user Input
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(stream: chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot) {
          //check for errors
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."),);
          }
          //return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user ?
    bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;

    //align messages
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment
        .centerLeft;
    return Container(
        alignment: alignment, child: ChatBubble(message: data['message'], currentUser: isCurrentUser,));
  }

  //user input
  Widget _buildUserInput(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          //text field
          Expanded(child: MyTextField(text: "Type a message",focusNode: myFocusNode,
            obscureText: false,
            controller: _messageController,)),

          //send Button
          Container(
            margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(100)
          ),
              child: IconButton(onPressed: sendMessage,
                  icon:  Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.secondary,))),


        ],
      ),
    );
  }
}
