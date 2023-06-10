import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/login.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/register.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportContrains) {
          return SingleChildScrollView(
            child: Column(children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 5, 130,
                        232), // Cambia "Colors.blue" por el color que desees
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Iniciar Sesión')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 5, 130,
                      232), // Cambia "Colors.blue" por el color que desees
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: const Text('Registrarse'),
              )
            ]),
          );
        }),
      ),
    ));
  }
}
