import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bjda.com/api/api_customer'; // Replace with your API URL

  Future fetchDataFromApi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/unavaliables/${600001}')); // Replace '/endpoint' with your API endpoint

      if (response.statusCode == 200) {
        // If the API call is successful
        final jsonData = json.decode(response.body);
        print('${jsonData['days']} //////////');
        return jsonData['days']; // Return the parsed JSON data as a List<dynamic>
      } else {
        // If the API call fails, throw an exception
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      throw Exception('Error: $e');
    }
  }


  Future<void> postDataToApi({Map<String, dynamic>? data}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'), // Replace '/endpoint' with your API endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data!),
      );

      if (response.statusCode == 200) {
        // If the API call is successful (status code 201: Created)
        print('Data posted successfully');
        print('${response.body}');
      } else {
        // If the API call fails, throw an exception
        throw Exception('${response.statusCode} ++ ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      throw Exception('ERROR: $e');
    }
  }

}
