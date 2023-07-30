import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your API URL

  Future<List<dynamic>> fetchDataFromApi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/endpoint')); // Replace '/endpoint' with your API endpoint

      if (response.statusCode == 200) {
        // If the API call is successful
        final jsonData = json.decode(response.body);
        return jsonData; // Return the parsed JSON data as a List<dynamic>
      } else {
        // If the API call fails, throw an exception
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      throw Exception('Error: $e');
    }
  }
}
