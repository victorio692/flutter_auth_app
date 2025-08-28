import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  final Color _primaryColor = Color(0xFF4CAF50);
  final Color _accentColor = Color(0xFFFF9800); 
  final Color _backgroundColor = Color(0xFFF5F5F5); 

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Beranda',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, _backgroundColor],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                'SELAMAT DATANG,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                authProvider.user?.name ?? '',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 24),

            
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.email_outlined,
                              size: 20, color: _primaryColor),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              authProvider.user?.email ?? '',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 20, color: _primaryColor),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Status: Aktif',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}