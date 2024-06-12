import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class VisionApi {
  final String keyFile;
  late final AutoRefreshingAuthClient _client;
  bool _clientInitialized = false;

  VisionApi(this.keyFile);

  Future<void> _initClient() async {
    if (!_clientInitialized) {
      final accountCredentials = ServiceAccountCredentials.fromJson(
        File(keyFile).readAsStringSync(),
      );
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
      _client = await clientViaServiceAccount(accountCredentials, scopes);
      _clientInitialized = true;
    }
  }

  Future<Map<String, dynamic>> analyzeImage(String imageBase64) async {
    await _initClient();
    final url = 'https://vision.googleapis.com/v1/images:annotate';

    final payload = jsonEncode({
      'requests': [
        {
          'image': {'content': imageBase64},
          'features': [
            {'type': 'FACE_DETECTION', 'maxResults': 1},
            {'type': 'LABEL_DETECTION', 'maxResults': 4},
          ]
        }
      ]
    });

    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: payload,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze image: ${response.statusCode} ${response.body}');
    }
  }

  String getHighestEmotion(Map<String, dynamic> emotions) {
    final likelihoods = {
      'joyLikelihood': _convertLikelihood(emotions['joyLikelihood']),
      'sorrowLikelihood': _convertLikelihood(emotions['sorrowLikelihood']),
      'angerLikelihood': _convertLikelihood(emotions['angerLikelihood']),
      'surpriseLikelihood': _convertLikelihood(emotions['surpriseLikelihood']),
    };

    final highestEmotion = likelihoods.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return highestEmotion.replaceFirst('Likelihood', '');
  }

  int _convertLikelihood(String likelihood) {
    switch (likelihood) {
      case 'VERY_UNLIKELY':
        return 1;
      case 'UNLIKELY':
        return 2;
      case 'POSSIBLE':
        return 3;
      case 'LIKELY':
        return 4;
      case 'VERY_LIKELY':
        return 5;
      default:
        return 0;
    }
  }

  void close() {
    _client.close();
  }
}
