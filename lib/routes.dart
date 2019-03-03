import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/camera_screen.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/CameraScreen': (BuildContext context) => CameraScreen(title: 'Receipt Parser'),
  };

  Routes() {
    //This will force the screen in portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MaterialApp(
        title: 'Receipt Parser',
        theme: ThemeData(
            primarySwatch: Colors.green, accentColor: Colors.greenAccent),
        home: new CameraScreen(title: "Receipt Parser",),
        routes: routes,
      ));
    });
  }
}
