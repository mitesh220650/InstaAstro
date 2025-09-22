import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/features/user/consultation/data/models/consultation_model.dart';
import 'package:instaastro_clone/features/user/consultation/data/repositories/consultation_repository_impl.dart';
import 'package:instaastro_clone/features/user/consultation/domain/repositories/consultation_repository.dart';

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ConsultationRepositoryImpl(apiClient);
});

final consultationHistoryProvider = FutureProvider<List<ConsultationModel>>((ref) async {
  final repository = ref.watch(consultationRepositoryProvider);
  return repository.getConsultationHistory();
});

final chatMessagesProvider = FutureProvider.family<List<ChatMessageModel>, String>((ref, consultationId) async {
  final repository = ref.watch(consultationRepositoryProvider);
  return repository.getChatMessages(consultationId);
});

final consultationProvider = StateNotifierProvider<ConsultationNotifier, ConsultationState>((ref) {
  final repository = ref.watch(consultationRepositoryProvider);
  return ConsultationNotifier(repository);
});

class ConsultationNotifier extends StateNotifier<ConsultationState> {
  final ConsultationRepository _repository;

  ConsultationNotifier(this._repository) : super(ConsultationState.initial());

  Future<void> startConsultation(String astrologerId, String type) async {
    state = state.copyWith(isLoading: true);
    try {
      final consultation = await _repository.startConsultation(astrologerId, type);
      state = state.copyWith(
        currentConsultation: consultation,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> endConsultation() async {
    if (state.currentConsultation == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final consultation = await _repository.endConsultation(state.currentConsultation!.id);
      state = state.copyWith(
        currentConsultation: consultation,
        isLoading: false,
        isActive: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendChatMessage(String message) async {
    if (state.currentConsultation == null) return;
    
    try {
      final chatMessage = await _repository.sendChatMessage(
        state.currentConsultation!.id,
        message,
      );
      
      state = state.copyWith(
        chatMessages: [...state.chatMessages, chatMessage],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadChatMessages() async {
    if (state.currentConsultation == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final messages = await _repository.getChatMessages(state.currentConsultation!.id);
      state = state.copyWith(
        chatMessages: messages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<String> generateAgoraToken(String channelName, String uid) async {
    if (state.currentConsultation == null) {
      throw Exception('No active consultation');
    }
    
    try {
      return await _repository.generateAgoraToken(
        state.currentConsultation!.id,
        channelName,
        uid,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  void addReceivedMessage(ChatMessageModel message) {
    state = state.copyWith(
      chatMessages: [...state.chatMessages, message],
    );
  }

  void resetState() {
    state = ConsultationState.initial();
  }
}

class ConsultationState {
  final ConsultationModel? currentConsultation;
  final List<ChatMessageModel> chatMessages;
  final bool isLoading;
  final bool isActive;
  final String? error;

  ConsultationState({
    this.currentConsultation,
    required this.chatMessages,
    required this.isLoading,
    required this.isActive,
    this.error,
  });

  factory ConsultationState.initial() {
    return ConsultationState(
      currentConsultation: null,
      chatMessages: [],
      isLoading: false,
      isActive: false,
    );
  }

  ConsultationState copyWith({
    ConsultationModel? currentConsultation,
    List<ChatMessageModel>? chatMessages,
    bool? isLoading,
    bool? isActive,
    String? error,
  }) {
    return ConsultationState(
      currentConsultation: currentConsultation ?? this.currentConsultation,
      chatMessages: chatMessages ?? this.chatMessages,
      isLoading: isLoading ?? this.isLoading,
      isActive: isActive ?? this.isActive,
      error: error,
    );
  }
}
