import 'package:bitcoin_ticker/services/networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<Map<String, String>> getCoinData(String currency) async {
    NetworkHelper networkHelper = NetworkHelper(coinAPIUrl);

    var results = await Future.wait(
      cryptoList.map(
        (crypto) => networkHelper.getData(
          crypto,
          currency,
        ),
      ),
    );

    var exchangeRates = <String, String>{};

    for (var item in results) {
      exchangeRates[item['asset_id_base']] = item['rate'].truncate().toString();
    }

    return exchangeRates;
  }
}
