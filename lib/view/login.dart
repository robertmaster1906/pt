import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/View/invitado.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import '../DTO/Usuario.dart';
import '../main.dart';
import 'Registro.dart';
import 'admin.dart';

class HomeStart extends State<Home> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  User objUser = User();

  LocalAuthentication auth = LocalAuthentication();

  Future<bool> biometrico() async {
    bool authenticated = false;
    const androidString = AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Ajustes",
      signInTitle: "Ingrese",
      //fingerprintNotRecognized: 'Error de reconocimiento de huella digital',
      goToSettingsDescription: "Confirme su huella",
      //fingerprintSuccess: 'Reconocimiento de huella digital exitoso',
      biometricHint: "Toque el sensor",
      //signInTitle: 'Verificación de huellas digitales',
      biometricNotRecognized: "Huella no reconocida",
      biometricRequiredTitle: "Required Title",
      biometricSuccess: "Huella reconocida",
      //fingerprintRequiredTitle: '¡Ingrese primero la huella digital!',
    );

    bool canCheckBiometrics = await auth.canCheckBiometrics;
    // bool isBiometricSupported = await auth.();
    bool isBiometricSupported = await auth.isDeviceSupported();

    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    print(canCheckBiometrics); //Returns trueB
    // print("support -->" + isBiometricSupported.toString());
    print(availableBiometrics.toString()); //Returns [BiometricType.fingerprint]
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Autentíquese para acceder",
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
          androidAuthStrings: androidString);
      if (!authenticated) {
        authenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    /* if (!mounted) {
        return;
      }*/

    return authenticated;
  }

  valDatos() async {
    bool flag = false;
    try {
      CollectionReference ref =
      FirebaseFirestore.instance.collection('usuarios');
      QuerySnapshot usuario = await ref.get();
      var bytes = utf8.encode(pass.text);
      var sha = sha256.convert(bytes);
      // datos que se procesan

      var digest = sha256.convert(bytes);

      if (usuario.docs.isNotEmpty) {
        for (var cursor in usuario.docs) {
          if (cursor.get('correoUsuario') == user.text) {
            if (cursor.get('passwordUsuario') == digest.toString()) {
              objUser.nombre = cursor.get('nombreUsuario');
              objUser.correo = cursor.get('correoUsuario');
              objUser.rol = cursor.get('Rol');
              objUser.estado = cursor.get('Estado');

              print(
                  "****** * acceso aceptado  * ******* clave ${pass.text}\n crypto:  $sha");

              mensaje('Mensaje', '¡ingreso Exitoso!', objUser);

              // ignore: prefer_interpolation_to_compose_strings, avoid_print
              print("estado -->" + cursor.get('estado'));
            } else {
              // ignore: avoid_print
              print("el usuario o la contraseña son incorrectas");
            }
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("error.....$e");
    }
  }

  void mensaje(String titulo, String contenido, objUser) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (objUser.rol == "Invitado") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Geoposition()));
                } else if (objUser.rol == "admin") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MyAdmin()));
                }
              },
              child: const Text('Aceptar')),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenidos',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('inicio'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                  width: 500,
                  height: 200,
                  child: Image.asset('img/user_v1.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: user,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                      labelText: 'Email Usuario',
                      hintText: 'Digite email de usuario '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: pass,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                      labelText: 'Password Usuario',
                      hintText: 'Digite password de usuario '),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    valDatos();
                  },
                  child: const Text('Enviar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Registro(objUser)));
                  },
                  child: const Text('registrar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    backgroundColor: Colors.black45,
                  ),
                  onPressed: () async {
                    if (await biometrico()) {
                      mensaje('Huella', 'Huella Encontrada', objUser);
                    }

                    //    print('success ' + isSuccess.toString());
                  },
                  child: const Icon(Icons.fingerprint, size: 80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}