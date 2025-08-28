import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator

  static Future<void> testConnection() async {
    try {
      print('🔗 Testing connection to Laravel API...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {'Accept': 'application/json'},
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ BERHASIL! API Connected: ${data['message']}');
        return data;
      } else {
        print('❌ Gagal: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERROR: $e');
      print('💡 Pastikan:');
      print('   - Laravel server running di port 8000');
      print('   - IP address benar (10.0.2.2 untuk Android emulator)');
      print('   - Tidak ada firewall yang memblokir');
    }
  }

  static Future<List<dynamic>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load items');
    }
  }
}