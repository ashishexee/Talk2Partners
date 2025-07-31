import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk2partners/providers/auth_provider.dart';
import '../services/chat_service.dart';
import '../models/message_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        print('Current user ID: ${user.uid}');
        return user.uid;
      }
      return '';
    },
    loading: () => '',
    error: (_, __) => '',
  );
});

final messagesProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  userId,
) {
  final chatService = ref.watch(chatServiceProvider);
  print('Getting messages for user ID: $userId');
  return chatService.getMessages(userId);
});

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  return ChatNotifier(ref.watch(chatServiceProvider));
});

class ChatState {
  final bool isSending;
  final String? error;
  ChatState({this.isSending = false, this.error});
  ChatState copyWith({bool? isSending, String? error}) {
    return ChatState(isSending: isSending ?? this.isSending, error: error);
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  ChatNotifier(this._chatService) : super(ChatState());
  Future<void> sendMessage(String senderId, String message) async {
    if (message.trim().isEmpty) return;
    state = state.copyWith(isSending: true, error: null);
    try {
      await _chatService.sendMessage(senderId, message);
      state = state.copyWith(isSending: false);
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
