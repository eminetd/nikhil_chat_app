// ignore_for_file: prefer_const_constructors

import 'package:chat_application/pages/home_page.dart';
import 'package:chat_application/pages/login_page.dart';
import 'package:chat_application/pages/register_page.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    '/login': (context) => LoginPage(),
    '/register':(context) => RegisterPage(),
    '/home': (context) => HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorkey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorkey = GlobalKey<NavigatorState>();
  }

void push(MaterialPageRoute route){
  _navigatorkey.currentState?.push(route);
}


  void pushNamed(String routename) {
    _navigatorkey.currentState?.pushNamed(routename);
  }

  void pushreplacementnamed(String routeName) {
    _navigatorkey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorkey.currentState?.pop();
  }
}
