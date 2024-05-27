import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> fetchTickerData() async {
    final response =
        await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> tickers = data['data'];
      return tickers;
    } else {
      throw Exception('Failed to load ticker data');
    }
  }
}