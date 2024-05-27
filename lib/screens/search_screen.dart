import 'package:flutter/material.dart';
import 'package:tugasakhir_tpm/screens/home_screen.dart';
import 'package:tugasakhir_tpm/screens/login_screen.dart';
import 'package:tugasakhir_tpm/screens/profile_screen.dart';
import '../services/session_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<dynamic> tickers;

  SearchScreen({required this.tickers});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<dynamic> filteredTickers;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 2;
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    filteredTickers = widget.tickers;
  }

  void filterTickers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredTickers = widget.tickers
            .where((ticker) =>
                ticker['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredTickers = widget.tickers;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 2:
        // Current screen
        break;
      case 3:
        _showAnnouncements();
        break;
      case 4:
        _logout();
        break;
    }
  }

  void _showAnnouncements() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Saran dan kesan',
            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Proses pembelajaran yang interaktif dan sering kali menantang, terutama dalam memecahkan masalah nyata dan menemukan solusi kreatif untuk kebutuhan aplikasi.',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(fontFamily: 'Montserrat')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await _sessionService.clearSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text(
          'Search for Cryptocurrencies',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Montserrat'),
              onChanged: filterTickers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTickers.length,
              itemBuilder: (context, index) {
                final ticker = filteredTickers[index];
                return ListTile(
                  title: Text(
                    ticker['name'],
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  subtitle: Text(
                    'Price USD: \$${ticker['price_usd']}',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(ticker: ticker),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Saran & kesan',
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
