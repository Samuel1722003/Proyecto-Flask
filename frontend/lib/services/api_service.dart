import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
 
  static const String baseUrl = "http://127.0.0.1:5000/api";

  /// Manejo seguro de respuestas
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          return {"msg": "Respuesta vacía del servidor"};
        }
      } else {
        return {
          "msg": "Error ${response.statusCode}",
          "body": response.body.isNotEmpty ? response.body : "Sin detalles"
        };
      }
    } catch (e) {
      return {"msg": "Respuesta inválida del servidor", "error": e.toString()};
    }
  }

  /// Registro de usuario
  static Future<Map<String, dynamic>> register(
      String email, String password, String name, String phone) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "phone": phone,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {"msg": "Error de conexión", "error": e.toString()};
    }
  }

  /// Login de usuario
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      return _handleResponse(response);
    } catch (e) {
      return {"msg": "Error de conexión", "error": e.toString()};
    }
  }

  /// Crear perfil
  static Future<Map<String, dynamic>> createProfile(
      String token, Map<String, dynamic> profileData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/profiles/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(profileData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {"msg": "Error de conexión", "error": e.toString()};
    }
  }

  /// Crear proyecto
  static Future<Map<String, dynamic>> createProject(
      String token, Map<String, dynamic> projectData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/projects/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(projectData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {"msg": "Error de conexión", "error": e.toString()};
    }
  }

  /// Guardar token en local storage
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  /// Leer token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  /// Borrar token (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}