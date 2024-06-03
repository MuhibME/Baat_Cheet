import 'package:baat_cheet/modal/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices{
  //instance of firestore
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream all the users available
  Stream<List<Map<String,dynamic>>> getUsersStream (){
    return _firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go thorough each user
        final user = doc.data();
        //return that user
        return user;
      },).toList();
    },);
  }


  ///send message
  Future<void> sendMessage(String receiverId , message)async{
    ///get current user info
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    ///create a new message
    Message newMessage =Message(senderID: currentUserId, senderEmail: currentUserEmail, receiverID: receiverId, message: message, timestamp: timestamp);


    ///chat room Id for two users
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //ensures id is in single order for any 2 people
    String chatRoomID = ids.join('_');

    ///adding new message to database
    await _firebaseFirestore.collection("chat_rooms").doc(chatRoomID).collection('messages').add(newMessage.toMap());

  }

  ///get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId){
    List<String> ids= [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    //messages
    return _firebaseFirestore.collection("chat_rooms").doc(chatRoomId).collection('messages').orderBy("timestamp", descending: false).snapshots();

  }
}