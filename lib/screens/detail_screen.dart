import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final dynamic ticker;

  DetailScreen({required this.ticker});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text(
          widget.ticker['name'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Symbol', widget.ticker['symbol']),
                _buildDetailRow('Price $selectedCurrency',
                    _convertPrice(widget.ticker['price_usd'])),
                _buildDetailRow('Percent Change 24h',
                    '${widget.ticker['percent_change_24h']}%'),
                _buildDetailRow('Percent Change 1h',
                    '${widget.ticker['percent_change_1h']}%'),
                _buildDetailRow('Percent Change 7d',
                    '${widget.ticker['percent_change_7d']}%'),
                _buildDetailRow('Volume 24h', '${widget.ticker['volume24']}'),
                _buildDetailRow('Total Supply', '${widget.ticker['tsupply']}'),
                _buildDetailRow('Max Supply', '${widget.ticker['msupply']}'),
                SizedBox(height: 20),
                Text(
                  'Convert Price to:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value!;
                    });
                  },
                  items: <String>['USD', 'IDR', 'SAR', 'EUR']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  String _convertPrice(String? priceUSD) {
    double price = double.tryParse(priceUSD ?? '0.0') ?? 0.0;
    switch (selectedCurrency) {
      case 'IDR':
        return 'Rp ${(price * 14250).toStringAsFixed(2)}';
      case 'SAR':
        return '﷼ ${(price * 3.75).toStringAsFixed(2)}';
      case 'EUR':
        return '€ ${(price * 0.82).toStringAsFixed(2)}';
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }
}
