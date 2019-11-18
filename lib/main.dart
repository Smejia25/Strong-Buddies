import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/routes.dart';

import 'package:strong_buddies_connect/themes/main_theme.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged)
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: routes(),
          theme: buildAppTheme(),
        ),
      );
}
