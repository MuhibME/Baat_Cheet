import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.currentUser});

  final String message;
  final bool currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const  EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      decoration: BoxDecoration(
        color: currentUser ? Theme.of(context).colorScheme.inversePrimary :Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12)
        
      ),
      child: Text(message, style: TextStyle( color: currentUser ? Theme.of(context).colorScheme.secondary :Theme.of(context).colorScheme.inversePrimary),
    ));
  }
}
