import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';

import '../../services/storage.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.avatarLink, required this.wallLink});
  ValueNotifier<String?> avatarLink;
  ValueNotifier<String?> wallLink;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  ValueNotifier<DateTime> birth = ValueNotifier(DateTime.now());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ValueNotifier<XFile?> _newWall = ValueNotifier(null);
  final ValueNotifier<XFile?> _newAvatar = ValueNotifier(null);


  @override
  void initState() {
    super.initState();
    _nameController.text = GlobalVariable.currentUser!.myUser.displayName;
    _bioController.text = GlobalVariable.currentUser!.myUser.bio;
  }

  Widget bottomSheetWidget(){
    return Container(
      height: 200,
      color: Colors.black,
      child: DatePickerWidget(
        looping: false, // default is not looping
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        initialDate: DateTime.now(),// DateTime(1994),
        dateFormat:
        "dd/MMMM/yyyy",
        locale: DatePicker.localeFromString('vi'),
        onChange: (DateTime newDate, _) {
          birth.value = newDate;
        },
        pickerTheme: const DateTimePickerTheme(
          backgroundColor: Colors.transparent,
          itemTextStyle:
          TextStyle(color: Colors.white, fontSize: 19),
          dividerColor: Colors.white,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.35,
                      color: Theme.of(context).dividerColor
                  )
              )
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "Edit profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            actions: [
              TextButton(
                  onPressed: ()  async{
                    String newWallPath  = GlobalVariable.currentUser!.myUser.wallLink;
                    String newAvatarPath  = GlobalVariable.currentUser!.myUser.avatarLink;
                    if(_newWall.value!= null){
                      newWallPath = await Storage().putImage(_newWall.value!, 'wall');
                    }
                    if(_newAvatar.value!= null){
                      newAvatarPath = await Storage().putImage(_newAvatar.value!, 'avatar');
                    }
                    MyUser user = MyUser(
                        uid: GlobalVariable.currentUser!.myUser.uid,
                        createDate: GlobalVariable.currentUser!.myUser.createDate,
                        bio: _bioController.text.trim(),
                        displayName: _nameController.text,
                        username:GlobalVariable.currentUser!.myUser.username,
                        wallLink: newWallPath,
                        avatarLink: newAvatarPath,
                        phoneNumber: GlobalVariable.currentUser!.myUser.phoneNumber,
                        email: GlobalVariable.currentUser!.myUser.email);
                    await DatabaseService().updateUserInfo(user, FirebaseAuth.instance);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // backgroundColor: Colors.transparent,
                        width: 180,
                        behavior: SnackBarBehavior.floating,
                        content: const Text('Update successful!'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 210),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      // fontWeight: FontWeight.w500
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 2), // Màu viền khi không được chọn
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(29, 161, 242, 1), width: 2), // Màu viền khi được chọn
                      ),
                      hintText:"Name cannot be blank",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6)
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none
                    ),
                    onChanged: (value) {

                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password!!";
                      }
                      return null;
                    },
                    onSaved: (value){
                    },
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    "Bio",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      // fontWeight: FontWeight.w500
                    ),
                  ),
                  TextFormField(
                    controller: _bioController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 2), // Màu viền khi không được chọn
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(29, 161, 242, 1), width: 2), // Màu viền khi được chọn
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none
                    ),
                    onChanged: (value) {

                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password!!";
                      }
                      return null;
                    },
                    onSaved: (value){
                    },
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    "Birth date",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      // fontWeight: FontWeight.w500
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var sheetController = showModalBottomSheet(
                          context: context,
                          builder: (context) => bottomSheetWidget());
                      sheetController.then((value) {});
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border(
                            bottom: BorderSide(color:Colors.white.withOpacity(0.6) , width: 2),
                        ),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: birth,
                        builder: (context, value, child){
                          return Text(
                            DateFormat('dd-MM-yyyy').format(value),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //wall
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async{
                  XFile? image = await ImagePicker().pickImage(
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 100,
                      source: ImageSource.gallery
                  );
                  if(image!=null){
                    _newWall.value = image;
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: _newWall,
                  builder: (context, value, child){
                    if(value!=null){
                      return  Container(
                          height: 150,
                          width:  MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(value.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.camera_viewfinder,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                      );
                    }else {
                      return Container(
                          height: 150,
                          width:  MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:NetworkImage(widget.wallLink.value!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.camera_viewfinder,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                      );
                    }

                  },
                ),
              ),
            ),
            // avatar
            Positioned(
              top: 150,
              left: 15,
              child: GestureDetector(
                onTap: () async{
                  XFile? image = await ImagePicker().pickImage(
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 100,
                      source: ImageSource.gallery
                  );
                  if(image!=null){
                    _newAvatar.value = image;
                  }
                },
                child: Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 3)
                    ),
                    child: Stack(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _newAvatar,
                          builder: (context, value, child){
                            if(value != null){
                              return CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 50,
                                backgroundImage: FileImage(File(value.path)),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                              backgroundImage: NetworkImage(widget.avatarLink.value!),
                            );
                          },
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(40)
                            ),

                          ),
                        ),
                        const Center(
                          child: Icon(
                            CupertinoIcons.camera_viewfinder,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
