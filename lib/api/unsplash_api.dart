import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var apiKey = 'ICeI3RzwDx1TQvI0orUkhQ2S_njt4JcSaQYui60NhtQ';
getData() async {
  http.Response response = await http.get(
    Uri.http('https://api.unslash.com/photos/?client_id=$apiKey'),
  );
  List imgData = jsonDecode(response.body);
}
