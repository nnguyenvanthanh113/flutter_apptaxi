import 'package:flutter/material.dart';
import 'package:flutterapptaxi/src/blocs/auth_bloc.dart';
import 'package:flutterapptaxi/src/resources/login_page.dart';

class MyApp extends InheritedWidget {

  final AuthBloc authBloc;
  final Widget child;
  MyApp(this.authBloc,this.child):super(child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp of(BuildContext context){
    return context.inheritFromWidgetOfExactType(MyApp);
  }
}
