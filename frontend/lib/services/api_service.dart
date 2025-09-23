import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://mysql-ccspria.alwaysdata.net/api";

  // Registro de usuario
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "phone": phone,
      }),
    );
    return jsonDecode(response.body);
  }

  // Login de usuario
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  // Crear perfil
  static Future<Map<String, dynamic>> createProfile(
    String token,
    Map<String, dynamic> profileData,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/profiles"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(profileData),
    );
    return jsonDecode(response.body);
  }

  // Crear proyecto
  static Future<Map<String, dynamic>> createProject(
    String token,
    Map<String, dynamic> projectData,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/projects"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(projectData),
    );
    return jsonDecode(response.body);
  }

  // Guardar token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  // Leer token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
}
