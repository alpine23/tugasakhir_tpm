import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tugasakhir_tpm/screens/search_screen.dart';
import '../services/session_service.dart';
import '../services/api_service.dart';
import '../services/timezone_service.dart';
import 'login_screen.dart';
import 'detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final SessionService _sessionService = SessionService();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureTickerData;
  late List<dynamic> tickers;
  late Timer _timer;
  late String currentTime = '';
  late String selectedZone = 'Asia/Jakarta';
  late List<dynamic> filteredTickers = [];
  final TimezoneService _timezoneService = TimezoneService();
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;

  final Map<String, String> timeZoneNames = {
    'Asia/Jakarta': 'WIB',
    'Asia/Makassar': 'WITA',
    'Asia/Jayapura': 'WIT',
    'Europe/London': 'London'
  };

  final List<String> timeZones = [
    'Asia/Jakarta',
    'Asia/Makassar',
    'Asia/Jayapura',
    'Europe/London'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
  }

  void _initializeData() {
    _timezoneService.setLocalLocation(selectedZone);
    futureTickerData = ApiService().fetchTickerData();
    futureTickerData.then((data) {
      setState(() {
        tickers = data;
        filteredTickers = tickers;
      });
    });
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      currentTime = _timezoneService.getCurrentDateTime(selectedZone);
    });
  }

  void _changeTimeZone(String zone) {
    setState(() {
      selectedZone = zone;
    });
    _timezoneService.setLocalLocation(selectedZone);
    _updateTime();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else if (index == 2) {
      _showAnnouncements();
    } else if (index == 3) {
      _logout();
    }
  }

  void _showAnnouncements() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Saran dan kesan',
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          content: Text(
              'Proses pembelajaran yang interaktif dan sering kali menantang, terutama dalam memecahkan masalah nyata dan menemukan solusi kreatif untuk kebutuhan aplikasi.',
              style: TextStyle(fontFamily: 'Montserrat')),
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
    await widget._sessionService.clearSession();
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
          'Cryptocurrency',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(tickers: tickers),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$currentTime',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedZone,
                items: timeZones.map((String zone) {
                  return DropdownMenuItem<String>(
                    value: zone,
                    child: Text(timeZoneNames[zone]!,
                        style: TextStyle(fontFamily: 'Montserrat')),
                  );
                }).toList(),
                onChanged: (String? newZone) {
                  if (newZone != null) {
                    _changeTimeZone(newZone);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 1),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureTickerData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredTickers.length,
                    itemBuilder: (context, index) {
                      final ticker = filteredTickers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading:
                                Icon(Icons.monetization_on, color: Colors.blue),
                            title: Text(
                              ticker['name'],
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Price USD: \$${ticker['price_usd']}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(ticker: ticker),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
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
              backgroundColor: Color.fromRGBO(143, 148, 251, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color.fromRGBO(143, 148, 251, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'Saran & kesan',
              backgroundColor: Color.fromRGBO(143, 148, 251, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
              backgroundColor: Color.fromRGBO(143, 148, 251, 1)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
