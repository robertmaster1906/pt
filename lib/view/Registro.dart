import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class Registro extends StatefulWidget {
  final User cadena;
  Registro(this.cadena);
  @override
  RegistroApp createState() => RegistroApp();
}

class RegistroApp extends State<Registro> {
  TextEditingController nombre = TextEditingController();
  TextEditingController identidad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController pass = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  insertarDatos() async {
    try {
      await firebase.collection('Usuarios').doc().set({
        "NombreUsuario": nombre.text,
        "IdentidadUsuario": identidad.text,
        "CorreoUsuario": correo.text,
        "TelefonoUsuario": telefono.text,
        "ContrasenaUsuario": pass.text,
        "Rol": "invidado",
        "Estado": true
      });
      print('Envio correcto');
      mensaje("informacion","registro correcto");

    } catch (e) {
      print('Error en insert......' + e.toString());
    }
  }
  void mensaje(String titulo,String contenido) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () {

                },
                child: Text('Aceptar', style:TextStyle(color: Colors.blueGrey)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuarios -->' + widget.cadena),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                  controller: nombre,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  style: TextStyle(color: Colors.lightGreen)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                  controller: identidad,
                  decoration: InputDecoration(labelText: 'Identificacion'),
                  style: TextStyle(color: Colors.lightGreen)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                  controller: correo,
                  decoration: InputDecoration(labelText: 'Correo electronico'),
                  style: TextStyle(color: Colors.lightGreen)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                  controller: telefono,
                  decoration: InputDecoration(labelText: 'Telefono'),
                  style: TextStyle(color: Colors.lightGreen)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                  controller: pass,
                  decoration: InputDecoration(labelText: 'Contrasena'),
                  style: TextStyle(color: Colors.lightGreen)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  print('contrasena original ${pass.text}');
                  pass.text = sha1.convert(utf8.encode(pass.text)).toString();
                  print('crypto SHA-1 :' + pass.text);
                  insertarDatos();
                  nombre.clear();
                  identidad.clear();
                  correo.clear();
                  telefono.clear();
                  pass.clear();
                },
                child: Text('Registrar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

