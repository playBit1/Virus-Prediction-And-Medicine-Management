import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicare/rest_api/config.dart';

class ApiService {
  static var client = http.Client();

  static Future<dynamic> postQuestions(virusName, userData) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.apiEndPoint);

    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode({
          'virusName': virusName,
          'userData': userData,
        }));

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);

      return data;
    }

    return null;
  }
}
