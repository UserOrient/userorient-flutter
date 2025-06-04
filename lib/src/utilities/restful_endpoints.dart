import 'package:userorient_flutter/src/models/endpoint.dart';

class RestfulEndpoints {
  const RestfulEndpoints._();

  static const String baseUrl = 'https://api.userorient.com';

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

  // {{base_url}}/sdk/feedback?projectId={{project_id}}
  static Endpoint sendFeedback({
    required String projectId,
    required String content,
    required String title,
    required String userId,
  }) {
    return Endpoint.post(
      url: '$baseUrl/sdk/feedback?projectId=$projectId',
      body: {
        'userId': userId,
        'description': {
          // TODO: For time being, pass the title and content as a single string.
          // TODO: We will change this to a more structured format in the future.
          'en': '$title\n\n$content',
        },
        'title': {
          'en': title,
        }
      },
    );
  }
}
