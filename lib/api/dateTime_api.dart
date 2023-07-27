
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> getData() async{
  final response = await http.get(
    Uri.parse(''),
    headers: {"Accept": "application/json"},
  );

  var convertData =  jsonDecode(response.body);

  return convertData;
}
