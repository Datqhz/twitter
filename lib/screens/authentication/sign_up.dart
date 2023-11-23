import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/services/auth_firebase.dart';

import '../../shared/loading.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                  "See what's happening in the world right now.",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 34),
                ),
                const SizedBox(
                  height: 180,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 60, 44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/gg-icon.png"),
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Continue with Google",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 100) / 2,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.2))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "or",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 85) / 2,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.2))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpStep1()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 60, 44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: const Text(
                    "Create account",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Flexible(
                  child: Wrap(
                    children: [
                      Text(
                        "By signing up, uou agree to our ",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 13.5),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      InkWell(
                        child: Text(
                          "Term",
                          style: TextStyle(color: Colors.blue, fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      Text(
                        ", ",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 13.5),
                      ),
                      InkWell(
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.blue, fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      Text(
                        ", and",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 13.5),
                      ),
                      InkWell(
                        child: Text(
                          "Cookie Use",
                          style: TextStyle(color: Colors.blue, fontSize: 13.5),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      Text(
                        ".",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 13.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 10,
                left: 0,
                child: Row(
                  children: [
                    Text(
                      "Have an account already?",
                      style: TextStyle(color: Theme.of(context).dividerColor),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/login-step-1');
                      },
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class SignUpStep1 extends StatefulWidget {
  const SignUpStep1({super.key});

  @override
  State<SignUpStep1> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _flexController = TextEditingController();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeFlex = FocusNode();
  bool _isNameFocused = false;
  bool _isFlexFocused = false;
  late bool _isBirthFocused;
  bool _isEmpty = true;
  bool _isPhone = true;
  String _displayName = "";
  String _info = "";
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  bool _isValid = true;
  late Timer _debounce = Timer(Duration(seconds: 2), (){});

  @override
  void initState() {
    super.initState();
    _isBirthFocused = false;
    _focusNodeName.addListener(() {
      setState(() {
        _isNameFocused = _focusNodeName.hasFocus;
        if(_isNameFocused){
          _isBirthFocused = false;
        }
      });
    });
    _focusNodeFlex.addListener(() {
      setState(() {
        _isFlexFocused = _focusNodeFlex.hasFocus;
        if(_isFlexFocused){
          _isBirthFocused = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _flexController.dispose();
    _focusNodeName.dispose();
    _focusNodeFlex.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _validateInput(String value) {
    if (_debounce != null && _debounce.isActive) {
      _debounce.cancel();
    }
    late RegExp regex;
    if(_isPhone){
      regex = RegExp(r'^\d{10}$');
    }else {
      regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    }
    _debounce = Timer(const Duration(seconds: 1), () {
      _isValid = true;
      _isEmpty =false;
      if (!regex.hasMatch(value)) {
          _isValid = false;
      }
      if(value.isEmpty){
        _isValid = true;
      }
      setState(() {
      });
    });
  }
  int _checkIsEmpty(){
    if(_nameController.text.isEmpty){
      return 1;
    }
    if(_flexController.text.isEmpty){
      return 2;
    }
    if(_selectedDate == null){
      return 3;
    }
    return 0;
  }

  Widget _showDatePicker(){
    return _isBirthFocused ? Container(
      child: DatePickerWidget(
        looping: false, // default is not looping
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        initialDate: DateTime.now(),// DateTime(1994),
        dateFormat:
        "dd/MMMM/yyyy",
        locale: DatePicker.localeFromString('vi'),
        onChange: (DateTime newDate, _) {
          setState(() {
            _selectedDate = newDate;
            _isEmpty =false;
          });
        },
        pickerTheme: const DateTimePickerTheme(
          backgroundColor: Colors.transparent,
          itemTextStyle:
          TextStyle(color: Colors.white, fontSize: 19),
          dividerColor: Colors.white,
        ),
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Icon(FontAwesomeIcons.xTwitter),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create your account",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 28),
              ),
              const SizedBox(
                height: 18,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _focusNodeName,
                        decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red.shade800), // Màu viền khi không được chọn
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor), // Màu viền khi không được chọn
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(29, 161, 242,
                                      1)), // Màu viền khi được chọn
                            ),
                            labelText: _isNameFocused ? 'Name' : null,
                            labelStyle: const TextStyle(fontSize: 14),
                            hintText: !_isNameFocused ? "Name" : null,
                            hintStyle: TextStyle(
                                color: Theme.of(context).dividerColor),
                            border: InputBorder.none),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none),
                        onChanged: (value) {
                          setState(() {
                            _isEmpty =false;
                            _displayName = value!;
                          });
                        },
                        // onSaved: (value) {
                        //   _displayName = value!;
                        // },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _flexController,
                        focusNode: _focusNodeFlex,
                        keyboardType: _isPhone?TextInputType.number:TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red.shade800), // Màu viền khi không được chọn
                            ),
                            focusedErrorBorder:
                            OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade800, // Màu viền khi được chọn
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor), // Màu viền khi không được chọn
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(29, 161, 242, 1)), // Màu viền khi được chọn
                            ),
                            labelText: _isFlexFocused ? (_isPhone?'Phone':"Email") : null,
                            labelStyle: const TextStyle(fontSize: 16),
                            errorText: !_isValid? (_isPhone?"Please enter the phone number valid.":"Please enter an email valid."):null,
                            hintText: !_isFlexFocused ? (_isPhone?"Phone":"Email") : null,
                            hintStyle: TextStyle(
                                color: Theme.of(context).dividerColor),
                            border: InputBorder.none),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none),
                        onChanged: (value) {
                          _validateInput(value);
                          _info = value!;
                        },
                        // onSaved: (value) {
                        //   _info = value!;
                        // },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusNodeFlex.unfocus();
                            _focusNodeName.unfocus();
                            _isBirthFocused = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 6),
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            border: Border(
                                top: BorderSide(color: _isBirthFocused?Colors.blue:Theme.of(context).dividerColor, width: 1),
                                bottom: BorderSide(color: _isBirthFocused?Colors.blue:Theme.of(context).dividerColor, width: 1),
                               left: BorderSide(color: _isBirthFocused?Colors.blue:Theme.of(context).dividerColor, width: 1),
                                right: BorderSide(color: _isBirthFocused?Colors.blue:Theme.of(context).dividerColor, width: 1)
                            ),
                          ),
                          child: Text(
                            _selectedDate!=null?DateFormat('dd-MM-yyyy').format(_selectedDate!):"Date of birth",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Theme.of(context).dividerColor, width: 0.5))),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                  children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isFlexFocused?ElevatedButton(
                      onPressed: (){
                        _focusNodeFlex.unfocus();
                        Future.delayed(Duration(milliseconds: 100), () {
                          setState(() {
                            _isPhone = !_isPhone;
                            _flexController.text = "";
                            _focusNodeFlex.requestFocus();
                          });
                        });

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          side: BorderSide(color: Theme.of(context).dividerColor, width: 1)
                      ),
                      child: Text(
                        _isPhone?"Use email instead":"Use phone instead",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ):Container(),
                    ElevatedButton(
                      onPressed: !_isEmpty ? () {
                              if (_checkIsEmpty()==0){
                                  Navigator.pushNamed(
                                      context,
                                      '/register-step-2',
                                      arguments: {
                                        'name': _displayName,
                                        'info': _info,
                                        'birth': _selectedDate
                                      }
                                  );
                              }else {
                                switch(_checkIsEmpty()){
                                  case 1:
                                    _focusNodeName.requestFocus();
                                    setState(() {
                                      _isEmpty = true;
                                    });
                                  case 2:
                                    _focusNodeFlex.requestFocus();
                                    setState(() {
                                      _isEmpty = true;
                                    });
                                  default:
                                    setState(() {
                                      _focusNodeFlex.unfocus();
                                      _focusNodeName.unfocus();
                                      _isBirthFocused = true;
                                      _isEmpty = true;
                                    });
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color.fromRGBO(212, 214, 223, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(
                              color: _isEmpty
                                  ? const Color.fromRGBO(212, 214, 223, 1)
                                  : Colors.white,
                              width: 1)),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
                    _showDatePicker()
               ]
              ),
            ))
      ]),
    );
  }
}

// class SignUpStep2 extends StatefulWidget {
//   const SignUpStep2({super.key});
//
//   @override
//   State<SignUpStep2> createState() => _SignUpStep2State();
// }
//
// class _SignUpStep2State extends State<SignUpStep2> {
//   bool _isChecked = true;
//   final AuthFirebaseService authFirebaseService = AuthFirebaseService();
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     final Map<String, dynamic> receivedData =
//     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//
//     final String name = receivedData['name'];
//     final String accout = receivedData['info'];
//     final DateTime birth  = receivedData['birth'];
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Icon(FontAwesomeIcons.xTwitter),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Stack(children: [
//         Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: Theme.of(context).primaryColor,
//           padding: const EdgeInsets.symmetric(horizontal: 50),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 40,),
//               Text(
//                 "Customize your experience",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20),
//               ),
//               SizedBox(height: 30,),
//               Text(
//                 "Track where you see X content across the web",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15),
//               ),
//               SizedBox(height: 30,),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 9,
//                     child: Text(
//                       "X users this data to personalize your experience. This web browsing history will never be stored with your name, email, or phone number.",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Checkbox(
//                         checkColor: Colors.black,
//                         value: _isChecked,
//                         onChanged: (check){
//                           setState(() {
//                             _isChecked = check!;
//                           });
//                         },
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         side: BorderSide(
//                           color: Colors.white,
//                           width: 2.5,
//                         ),
//
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: 30,),
//               Wrap(
//                 children: [
//                   Text(
//                     "By signing up, uou agree to our ",
//                     style: TextStyle(
//                         color: Theme.of(context).dividerColor,
//                         fontSize: 13.5),
//                   ),
//                   SizedBox(
//                     width: 2,
//                   ),
//                   InkWell(
//                     child: Text(
//                       "Term",
//                       style: TextStyle(color: Colors.blue, fontSize: 13.5),
//                     ),
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                   Text(
//                     ", ",
//                     style: TextStyle(
//                         color: Theme.of(context).dividerColor,
//                         fontSize: 13.5),
//                   ),
//                   InkWell(
//                     child: Text(
//                       "Privacy Policy",
//                       style: TextStyle(color: Colors.blue, fontSize: 13.5),
//                     ),
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                   Text(
//                     ", and ",
//                     style: TextStyle(
//                         color: Theme.of(context).dividerColor,
//                         fontSize: 13.5),
//                   ),
//                   InkWell(
//                     child: Text(
//                       "Cookie Use",
//                       style: TextStyle(color: Colors.blue, fontSize: 13.5),
//                     ),
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                   Text(
//                     ". X may use your contact infomation, including your email address and phone number for purposes outlined in our Privacy Policy. ",
//                     style: TextStyle(
//                         color: Theme.of(context).dividerColor,
//                         fontSize: 13.5),
//                   ),
//                   InkWell(
//                     child: Text(
//                       "Learn more",
//                       style: TextStyle(color: Colors.blue, fontSize: 13.5),
//                     ),
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               alignment: Alignment.centerRight,
//               decoration: BoxDecoration(
//                   border: Border(
//                       top: BorderSide(
//                           color: Theme.of(context).dividerColor, width: 0.1))),
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                         ElevatedButton(
//                           onPressed: (){
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               disabledBackgroundColor:
//                               const Color.fromRGBO(212, 214, 223, 1),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               side: BorderSide(
//                                   color: Colors.white, width: 1)),
//                           child: const Text(
//                             "Next",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                                 fontSize: 16),
//                           ),
//                         )
//                   ]
//               ),
//             ))
//       ]),
//     );
//   }
// }
class SignUpStep2 extends StatefulWidget {
  SignUpStep2({super.key});
  @override
  State<SignUpStep2> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {

  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isEmpty = true;
  final _formKey = GlobalKey<FormState>();
  String _password = "";
  bool _isObscure = true;
  bool _loading = false;
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
    final Map<String, dynamic> receivedData =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String name = receivedData['name'];
    final String account = receivedData['info'];
    final DateTime birth  = receivedData['birth'];
    print('account: ' + account);
    return _loading?const Loading():Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              });
                            }

                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password!!";
                            }
                            return null;
                          },
                          onSaved: (value){
                            _password = value!;
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      ElevatedButton(
                        onPressed: !_isEmpty?() async{
                          if(_formKey.currentState!.validate()){
                            _formKey.currentState?.save();
                            setState(() {
                              _loading  = true;
                            });
                            dynamic result = await _authFirebaseService.registerWithEmailAndPassword(account, _password, name, birth );
                            if(result == null) {
                              setState(() {
                                _loading = false;
                              });
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpSuccess()));
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
                          "Create",
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

class SignUpSuccess extends StatelessWidget {
  const SignUpSuccess({super.key});

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
                  "Welcome to twitter. Let's start connecting to the world now.",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 34
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route)=>false);
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
                    "Return to login page",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


