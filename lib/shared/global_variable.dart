

import 'package:flutter/cupertino.dart';
import 'package:twitter/screens/authentication/sign_in.dart';
import 'package:twitter/screens/authentication/sign_up.dart';
import 'package:twitter/screens/home/home.dart';

class GlobalVariable{

  static double paddingScreen = 15;
  static Map<String, WidgetBuilder>  routes = {
    '/home' : (context) => Home(),
    '/login' : (context) => SignIn(),
    '/login-step-1': (context) => SignInStep1(),
    '/login-step-2' : (context) => SignInStep2(),
    '/register' : (context) => SignUp(),
    '/register-step-2': (context) =>SignUpStep2()
  };
}
