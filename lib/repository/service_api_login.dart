import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/model/login_response_model.dart';

class APIService {
  static var client = http.Client();

static Future<LoginResponseModel> login(LoginRequestModel model) async {
  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  var url = Uri.parse('https://a-c-soluciones.onrender.com/api/login');

  print('🔹 Enviando solicitud POST a: $url');
  print('🔹 Datos enviados: ${jsonEncode(model.toJson())}');

  var response = await client.post(
    url,
    headers: requestHeaders,
    body: jsonEncode(model.toJson()),
  );

  print('🔸 Código de estado: ${response.statusCode}');
  print('🔸 Respuesta del servidor: ${response.body}');

  if (response.statusCode == 200) {
    return loginResponseJson(response.body);
  } else {
    throw Exception('Error al iniciar sesión: ${response.statusCode}');
  }
}

}
