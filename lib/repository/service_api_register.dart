// import 'package:flutter_a_c_soluciones/server/conexion.dart';
import 'dart:convert';

import 'package:flutter_a_c_soluciones/model/register_request_model.dart';
import 'package:flutter_a_c_soluciones/model/register_response_model.dart';
import 'package:http/http.dart' as http;

class APIServiceRegister {
  var client = http.Client();

  Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    final url = Uri.parse(
      'https://flutter-58c3.onrender.com/api/cliente',
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return registerResponseJson(response.body);
    } else {
      throw Exception('Error al registrarse');
    }
  }
}
