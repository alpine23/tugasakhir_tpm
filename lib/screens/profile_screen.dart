import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user.dart';
import '../services/db_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  final DBService _databaseHelper = DBService();
  final SessionService _sessionService = SessionService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
              style: TextStyle(fontFamily: 'Montserrat')),
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
    await _sessionService.clearSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _loadUserData() async {
    final username = await _sessionService.getSession();
    if (username != null) {
      final user = await _databaseHelper.getUser(username);
      setState(() {
        _currentUser = user;
        _passwordController.text = user?.password ?? '';
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = _currentUser;
      if (user != null) {
        user.profilePicture = pickedFile.path;
        await _databaseHelper.updateUser(user);
        setState(() {
          _currentUser = user;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipOval(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _currentUser!.profilePicture == null
                                  ? AssetImage(
                                      'assets/images/default_profile.png')
                                  : FileImage(
                                          File(_currentUser!.profilePicture!))
                                      as ImageProvider<Object>,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _updateProfilePicture,
                      child: Text('Change Profile Picture',
                          style: TextStyle(fontFamily: 'Montserrat')),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: _currentUser!.username,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        labelStyle:
                            TextStyle(color: Colors.blue),
                        prefixIcon: Icon(Icons.person,
                            color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      readOnly: true,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Encrypted Password',
                        labelStyle:
                            TextStyle(color: Colors.blue),
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
