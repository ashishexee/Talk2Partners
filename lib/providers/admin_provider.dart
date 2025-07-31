import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chat_service.dart';
import '../models/message_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final adminChatroomsProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getAdminChatrooms();
});

final selectedUserMessagesProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, userId) {
      final chatService = ref.watch(chatServiceProvider);
      return chatService.getMessages(userId);
    });
