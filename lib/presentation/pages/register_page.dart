import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => !v!.contains('@') ? 'Email tidak valid' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Min 6 karakter' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registrasi berhasil')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Daftar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
