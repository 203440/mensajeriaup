import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/login.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/register.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(
            71, 134, 250, 1), // Cambia "Colors.white" por el color que desees
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150, left: 50, right: 50),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'UpChat',
                        style: TextStyle(
                          fontSize: 50, // Tamaño de fuente de 24
                          color: Colors.white, // Color de texto blanco
                        ),
                      ),
                      const SizedBox(height: 60.0),
                      Image.asset(
                        'assets/logo.png', // Ruta de la imagen en tu proyecto
                        width: 150, // Ancho de la imagen
                        height: 150, // Alto de la imagen
                      ),
                      const SizedBox(height: 60.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(252, 252, 252, 252),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text('Iniciar Sesión'),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(252, 252, 252, 252),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: const Text('Registrarse'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
