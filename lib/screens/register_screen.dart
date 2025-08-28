import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final Color _primaryColor = Color(0xFF4CAF50); // Hijau
  final Color _accentColor = Color(0xFFFF9800); // Oranye
  final Color _backgroundColor = Color(0xFFF5F5F5); // Abu-abu muda

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Daftar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo/Icon
                  Icon(
                    Icons.person_add,
                    size: 80,
                    color: _primaryColor,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Isi data diri Anda untuk mendaftar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person, color: _primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan nama lengkap Anda';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email, color: _primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan email Anda';
                      if (!value.contains('@')) return 'Masukkan email yang valid';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock, color: _primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword 
                            ? Icons.visibility 
                            : Icons.visibility_off,
                            color: _primaryColor),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan kata sandi';
                      if (value.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: _primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword 
                            ? Icons.visibility 
                            : Icons.visibility_off,
                            color: _primaryColor),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Konfirmasi kata sandi Anda';
                      if (value != _passwordController.text) return 'Kata sandi tidak cocok';
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authProvider.register(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                            _confirmPasswordController.text,
                          );
                          
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pendaftaran berhasil'),
                                backgroundColor: _primaryColor,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.error ?? 'Pendaftaran gagal'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: authProvider.isLoading 
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text('DAFTAR', 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah punya akun? '),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Masuk',
                            style: TextStyle(
                              color: _accentColor,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}