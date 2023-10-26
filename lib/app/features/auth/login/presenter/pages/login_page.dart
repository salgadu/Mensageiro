import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mensageiro/app/features/auth/login/presenter/pages/login_controller.dart';

class LoginPage extends StatefulWidget {
  final LoginController controller;
  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var number = MaskTextInputFormatter(
      mask: '+55 (##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.controller.isLoading) {
        return const Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 15,
              ),
              Text('Realizando Login...')
            ],
          ),
        );
      }
      if (widget.controller.isError) {
        return Center(
          child: Column(
            children: [
              Text(
                  'Falha ao realizar login: ${widget.controller.messageError}'),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () => widget.controller.setError(false),
                  child: const Text('Ok'))
            ],
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phone,
                inputFormatters: [number],
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Increased spacing
              TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Increased spacing
              ElevatedButton(
                onPressed: () async {
                  widget.controller.singIn(
                      phone: phone.text.replaceAll(RegExp(r'[^0-9]'), ''),
                      password: password.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6651F6), // Viber Purple
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(200, 50), // Larger button size
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
