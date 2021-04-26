import 'dart:convert';
import 'package:http/http.dart';

class NetworkHelper {
  final String url;
  final headers = {
    'X-CoinAPI-Key': 'API_KEY',
  };

  NetworkHelper(this.url);

  Future getData(String crypto, String currency) async {
    Response response =
        await get(Uri.parse('$url/$crypto/$currency'), headers: headers);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
