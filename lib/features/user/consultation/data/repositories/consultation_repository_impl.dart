import 'package:instaastro_clone/core/network/api_client.dart';
import 'package:instaastro_clone/core/network/api_constants.dart';
import 'package:instaastro_clone/features/user/consultation/data/models/consultation_model.dart';
import 'package:instaastro_clone/features/user/consultation/domain/repositories/consultation_repository.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  final ApiClient _apiClient;

  ConsultationRepositoryImpl(this._apiClient);

  @override
  Future<ConsultationModel> startConsultation(
    String astrologerId,
    String type,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.startConsultation,
        data: {
          'astrologer_id': astrologerId,
          'type': type,
        },
      );
      
      return ConsultationModel.fromJson(response.data['consultation']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ConsultationModel> endConsultation(String consultationId) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.endConsultation,
        data: {
          'consultation_id': consultationId,
        },
      );
      
      return ConsultationModel.fromJson(response.data['consultation']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ConsultationModel>> getConsultationHistory() async {
    try {
      final response = await _apiClient.get(ApiConstants.consultationHistory);
      
      final List<dynamic> data = response.data['consultations'];
      return data.map((json) => ConsultationModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(String consultationId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.consultations}/$consultationId/messages',
      );
      
      final List<dynamic> data = response.data['messages'];
      return data.map((json) => ChatMessageModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatMessageModel> sendChatMessage(
    String consultationId,
    String message,
  ) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.consultations}/$consultationId/messages',
        data: {
          'message': message,
        },
      );
      
      return ChatMessageModel.fromJson(response.data['message']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> generateAgoraToken(
    String consultationId,
    String channelName,
    String uid,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.generateAgoraToken,
        data: {
          'consultation_id': consultationId,
          'channel_name': channelName,
          'uid': uid,
        },
      );
      
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }
}
