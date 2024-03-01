import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/auth/user_auth.dart';
import 'package:twitter/services/auth_firebase.dart';
import 'package:twitter/services/firebase_database.dart';
import 'package:twitter/shared/global_variable.dart';
import 'package:twitter/services/storage.dart';

import '../../services/database_service.dart';
class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(FontAwesomeIcons.xTwitter),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back! Log in to see the latest.",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 34
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(
                          MediaQuery.of(context).size.width-60,
                          44
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      )
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/gg-icon.png"),
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 8,),
                      Text(
                        "Continue with Google",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 4,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 100)/2,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.2
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "or",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 12
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 85)/2,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.2
                              )
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/login-step-1');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      minimumSize: Size(
                          MediaQuery.of(context).size.width-60,
                          44
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      )
                  ),
                  child: const Text(
                    "Log In",
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 10,
                left: 0,
                child: Row(
                  children: [
                    Text("Don't have an account?",
                      style: TextStyle(
                      color: Theme.of(context).dividerColor
                      ),
                    ),
                    SizedBox(width: 2,),
                    InkWell(
                      child: Text("Sign up",
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                    )
                  ],
                )
            )
          ],

        ),
      ),
    );
  }
}

class SignInStep1 extends StatefulWidget {
  const SignInStep1({super.key});

  @override
  State<SignInStep1> createState() => _SignInStep1State();
}

class _SignInStep1State extends State<SignInStep1> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isEmpty = true;
  String _username = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Icon(FontAwesomeIcons.xTwitter),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "To get started, first enter your phone, email, or @username",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28
                  ),
                ),
                const SizedBox(height: 18,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).dividerColor), // Màu viền khi không được chọn
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(29, 161, 242, 1)), // Màu viền khi được chọn
                            ),
                            labelText: _isFocused? 'Phone, email, or username':null,
                            labelStyle:const TextStyle(
                                fontSize: 16
                            ) ,
                            hintText:!_isFocused?"Phone, email, or username":null,
                            hintStyle: TextStyle(
                                color: Theme.of(context).dividerColor
                            ),
                            border: InputBorder.none
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.none
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _isEmpty = true;
                            });
                          }else {
                            setState(() {
                              _isEmpty = false;
                              _username = value;
                            });
                          }

                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your username!!";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)
                    )
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          side: BorderSide(color: Theme.of(context).dividerColor, width: 1)
                        ),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                    ),
                    ElevatedButton(
                      onPressed: !_isEmpty?() async{
                        if(_formKey.currentState!.validate()){
                          print('username '  + _username );
                          bool check = await FirebaseDatabase(uid: '').findAccountByEmail(_username);
                          if(check){
                            Navigator.popAndPushNamed(context,'/login-step-2', arguments: _username);
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // backgroundColor: Colors.transparent,
                                width: 2.6*MediaQuery.of(context).size.width/4,
                                behavior: SnackBarBehavior.floating,
                                content: const Text('Sorry, we not could not find your account.'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }

                      }: null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          disabledBackgroundColor: const Color.fromRGBO(212,214, 223, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          side: BorderSide(color: _isEmpty?const Color.fromRGBO(212,214, 223, 1):Colors.white, width: 1)
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ],
                ),
              )
          )
        ]
      ),
    );
  }
}

class SignInStep2 extends StatefulWidget {
  SignInStep2({super.key});

  @override
  State<SignInStep2> createState() => _SignInStep2State();
}

class _SignInStep2State extends State<SignInStep2> {

  final AuthFirebaseService authFirebaseService = AuthFirebaseService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isEmpty = true;
  final _formKey = GlobalKey<FormState>();
  String _password = "";
  bool _isObscure = true;
  DatabaseService _databaseService = DatabaseService();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Icon(FontAwesomeIcons.xTwitter),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your password",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 28
                    ),
                  ),
                  const SizedBox(height: 18,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          initialValue: username,
                          decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).dividerColor), // Màu viền khi không được chọn
                              ),
                              border: InputBorder.none
                          ),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextFormField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).dividerColor), // Màu viền khi không được chọn
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(29, 161, 242, 1)), // Màu viền khi được chọn
                              ),
                              labelText: _isFocused? 'Password':null,
                              labelStyle:const TextStyle(
                                  fontSize: 16
                              ) ,
                              hintText:!_isFocused?"Password":null,
                              hintStyle: TextStyle(
                                  color: Theme.of(context).dividerColor
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon:_isObscure? const Icon(Icons.remove_red_eye_outlined):const Icon(Icons.remove_red_eye),
                              ),
                            suffixStyle: TextStyle(
                              color: Theme.of(context).dividerColor
                            )
                          ),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),
                          obscureText: _isObscure,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _isEmpty = true;
                              });
                            }else {
                              setState(() {
                                _isEmpty = false;
                                _password = value;
                              });
                            }

                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password!!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)
                    )
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            side: BorderSide(color: Theme.of(context).dividerColor, width: 1)
                        ),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: !_isEmpty?()async{
                          if(_formKey.currentState!.validate()){
                            print('password: ' + _password);
                            dynamic result = await authFirebaseService.signInWithEmailAndPassword(username, _password) ;
                            if(result == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  width: 145,
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text('Wrong password.'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }else {
                              _databaseService.getUserInfo();
                              Navigator.pop(context);

                            }
                          }
                        }: null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            disabledBackgroundColor: const Color.fromRGBO(212,214, 223, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            side: BorderSide(color: _isEmpty?const Color.fromRGBO(212,214, 223, 1):Colors.white, width: 1)
                        ),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
          ]
      ),
    );
  }
}

