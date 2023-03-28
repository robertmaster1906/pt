import 'dart:html';

import 'package:flutter/material.dart';

class Geoposition extends StatefulWidget {
  const Geoposition({super.key});

  @override
  GeopositionApp createState() => GeopositionApp();
}

class GeopositionApp extends State<Geoposition> {
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  late Position position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                    longitud.text= await determinePosition().toString();
                    onPressed: () {}, child: const Text('Ubicación')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: latitud,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: false,
                      labelText: 'latitud'),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      enabled: false

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      enabled: false

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
    } else {
      Geolocator.openLocationSettings();
    }
    if (!serviceEnabled) {
      return Future.error('No disponible');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == await LocationPermission.denied) {
        return Future.error('Permiso denegado');
      }
    }
    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }
}