import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String adminUid = 'admin_uid_123'; // Static admin UID

  String getChatroomId(String userId) {
    final chatroomId = '${userId}_$adminUid';
    print(
      'ChatService: Creating chatroom ID for user: $userId -> $chatroomId',
    ); // Debug line
    return chatroomId;
  }

  Future<void> sendMessage(String senderId, String message) async {
    String chatroomId = getChatroomId(senderId);
    MessageModel newMessage = MessageModel(
      id: '',
      senderId: senderId,
      receiverId: adminUid,
      message: message,
      timestamp: DateTime.now(),
    );
    await _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toMap());

    await _firestore.collection('chatrooms').doc(chatroomId).set({
      'participants': [senderId, adminUid],
      'lastMessage': message,
      'lastMessageTime': Timestamp.fromDate(DateTime.now()),
      'userId':
          senderId,
    }, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> getMessages(String userId) {
    String chatroomId = getChatroomId(userId);

    return _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }
}
