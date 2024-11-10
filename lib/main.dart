import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:user_repository/user_repository.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Desactiva la actualización automática de tokens para evitar solicitudes excesivas
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);

  // Activa App Check con el token de depuración en modo desarrollo
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
