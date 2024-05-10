import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/auth_view.dart';
import 'package:twitter/screens/authentication/sign_in.dart';
import '../auth/user_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth?>(context);
/*    print(user);*/
    return user==null? const SignIn() : const AuthNavigation();
  }
}
