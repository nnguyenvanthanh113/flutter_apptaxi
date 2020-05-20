import 'package:flutter/material.dart';
import 'package:flutterapptaxi/src/app.dart';
import 'package:flutterapptaxi/src/blocs/auth_bloc.dart';
import 'package:flutterapptaxi/src/resources/login_page.dart';


void main() => runApp(MyApp(new AuthBloc(), MaterialApp(
  home: LoginPage(),
)));

