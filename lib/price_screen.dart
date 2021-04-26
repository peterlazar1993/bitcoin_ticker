import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;
  Map<String, String> exchangeRates = {};
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    isFetching = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isFetching = false;
      setState(() {
        exchangeRates = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              for (var crypto in cryptoList)
                CoinsListItem(
                  crypto: crypto,
                  selectedCurrency: selectedCurrency,
                  rate: isFetching ? '?' : exchangeRates[crypto]!,
                ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker getIOSPicker() {
    var pickerItems = [
      for (var currency in currenciesList)
        Text(
          currency,
        ),
    ];
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: pickerItems,
      itemExtent: 32,
      onSelectedItemChanged: (value) {
        var selected = currenciesList[value];
        onSelectCurrency(selected);
      },
    );
  }

  void onSelectCurrency(String selected) async {
    setState(() {
      selectedCurrency = selected;
      getData();
    });
  }

  DropdownButton getAndroidPicker() {
    var dropdownItems = [
      for (var currency in currenciesList)
        DropdownMenuItem(
          child: Text(
            currency,
          ),
          value: currency,
        ),
    ];

    return DropdownButton<String>(
      items: dropdownItems,
      onChanged: (value) {
        onSelectCurrency(value!);
      },
      value: selectedCurrency,
    );
  }
}

class CoinsListItem extends StatelessWidget {
  final String crypto;
  final String selectedCurrency;
  final String rate;

  const CoinsListItem({
    Key? key,
    required this.rate,
    required this.crypto,
    required this.selectedCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 28.0,
          ),
          child: Text(
            '1 $crypto = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
