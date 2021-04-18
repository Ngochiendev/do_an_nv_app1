import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/messages.dart';

class FireStoreDatabaseMessage{
  Future<void> upLoadMessage(String message, DateTime date) async{
    return await FirebaseFirestore.instance.collection('messages').add({
        'senderID' : 'nv',
        'sender': 'Nhân viên',
        'message': message,
        'createAt': date
    });
  }
  Stream<List<MessagesSnapshot>> getMessageFromFirebase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('messages')
        .orderBy('createAt', descending: true)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
      querySnapshot.docs.map((DocumentSnapshot docs) =>
          MessagesSnapshot.fromSnapshot(docs)
      ).toList()
    );
  }
}
