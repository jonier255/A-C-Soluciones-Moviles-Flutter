import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/model/tecnico_model.dart';

class TecnicosRepository {
  Future<List<Tecnico>> getTecnicos() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/tecnico');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Tecnico.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tecnicos');
    }
  }
}
