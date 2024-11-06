import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isObscured = true;
  bool _passwordTouched = false;
  bool _emailTouched = false;
  bool _isValid = false;
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No se encontró un usuario con ese correo.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta.';
            break;
          default:
            errorMessage = 'Ocurrió un error: ${e.message}';
        }
        _showErrorDialog(errorMessage);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error de inicio de sesión'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (!_emailTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Inicio de sesión'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/snoopyAzul.jpg',
                width: 155,
                height: 170,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: _validateEmail,
                  onTap: () {
                    setState(() {
                      _emailTouched = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        color: const Color.fromRGBO(130, 48, 56, 1),
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                  onTap: () {
                    setState(() {
                      _passwordTouched = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                    ),
                    onPressed: _login,
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: const [
                  Text('hola'),
                  Text('hola'),
                  Text('hola'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
