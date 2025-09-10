import 'package:userorient_flutter/src/models/endpoint.dart';

class RestfulEndpoints {
  const RestfulEndpoints._();

  // static const String baseUrl = 'https://api.userorient.com';
  static const String baseUrl = 'http://localhost:3000';

  static Endpoint projectDetails(String projectId) {
    return Endpoint.get(
      url: '$baseUrl/sdk/project/details?projectId=$projectId',
    );
  }

  static Endpoint features({
    required String apiKey,
    required String userId,
  }) {
    return Endpoint.get(
      url: '$baseUrl/sdk/feature/all?projectId=$apiKey&userId=$userId',
    );
  }

  static Endpoint syncUser(String projectId) {
    return Endpoint.post(
      url: '$baseUrl/sdk/user/sync?projectId=$projectId',
    );
  }

  static Endpoint toggleUpvote({
    required String projectId,
    required String userId,
    required String featureId,
  }) {
    return Endpoint.post(
      url: '$baseUrl/sdk/feature/toggle?projectId=$projectId',
      body: {
        'userId': userId,
        'featureId': featureId,
      },
    );
  }

  static Endpoint sendFeedback({
    required String projectId,
    required String content,
    required String userId,
  }) {
    return Endpoint.post(
      url: '$baseUrl/sdk/feedback?projectId=$projectId',
      body: {
        'userId': userId,
        'description': {
          'en': content,
        },
      },
    );
  }

  static Endpoint comments({
    required String projectId,
    required String userId,
    required String featureId,
  }) {
    return Endpoint.get(
      url:
          '$baseUrl/sdk/comment/all?projectId=$projectId&userId=$userId&featureId=$featureId',
    );
  }

  static Endpoint addComment({
    required String projectId,
    required String userId,
    required String featureId,
    required String content,
  }) {
    return Endpoint.post(
      url: '$baseUrl/sdk/comment?projectId=$projectId',
      body: {
        'userId': userId,
        'featureId': featureId,
        'content': content,
      },
    );
  }
}
