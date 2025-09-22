import 'package:instaastro_clone/features/user/consultation/data/models/consultation_model.dart';

abstract class ConsultationRepository {
  Future<ConsultationModel> startConsultation(
    String astrologerId,
    String type,
  );
  
  Future<ConsultationModel> endConsultation(String consultationId);
  
  Future<List<ConsultationModel>> getConsultationHistory();
  
  Future<List<ChatMessageModel>> getChatMessages(String consultationId);
  
  Future<ChatMessageModel> sendChatMessage(
    String consultationId,
    String message,
  );
  
  Future<String> generateAgoraToken(
    String consultationId,
    String channelName,
    String uid,
  );
}
