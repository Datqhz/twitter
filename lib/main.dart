import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/wrapper.dart';
import 'package:twitter/services/auth_firebase.dart';
import 'package:twitter/shared/global_variable.dart';

import 'auth/user_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserAuth?>.value(
      value: AuthFirebaseService().user,
      initialData: null,
      catchError: (_,__){},
      child: MaterialApp(
            theme: ThemeData(
              dividerColor: Colors.blue.shade50,
                backgroundColor: Colors.black,
                primaryColor: Colors.black,
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.black,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.white
                ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:const Color.fromRGBO(29, 161, 242, 1)
                )
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)
              ),

            ),
            routes: GlobalVariable.routes,
            home: SafeArea(
              child: Wrapper(),
            ),
          debugShowCheckedModeBanner: false,
      ),
    );
  }
}
