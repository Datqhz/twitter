import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/models/user_info_with_follow.dart';
import 'package:twitter/screens/community/search-user.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';

import '../../models/group.dart';
import '../../models/user.dart';
import '../../services/storage.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _ruleNameController = TextEditingController();
  final TextEditingController _ruleDesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formCommunitiesNameKey = GlobalKey<FormState>();

  ValueNotifier<List<String>> ruleNames = ValueNotifier([]);
  ValueNotifier<List<String>> ruleDes = ValueNotifier([]);
  ValueNotifier<List<MyUser>> member = ValueNotifier([]);
  ValueNotifier<XFile?> communitiesImg = ValueNotifier(null);

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      List<String> newList = List.from(ruleNames.value);
      newList.add(_ruleNameController.text); // Change the element
      ruleNames.value = newList;
      newList = List.from(ruleDes.value);
      newList.add(_ruleDesController.text); // Change the element
      ruleDes.value = newList;
      _ruleNameController.text = '';
      _ruleDesController.text = '';
      Navigator.pop(context);
    }
  }
  void _removeRule(int idx){
    List<String> newList = List.from(ruleNames.value);
    newList.removeAt(idx); // Change the element
    ruleNames.value = newList;
    newList = List.from(ruleDes.value);
    newList.removeAt(idx); // Change the element
    ruleDes.value = newList;
    Navigator.pop(context);
  }
  List<Widget> buildRules(List<String> value){
    List<Widget> rs = [];
    for(int i in List.generate(value.length, (index) => index)){
      rs.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width:26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(17)
                ),
                child: Text((i+1).toString(), style: TextStyle(
                    color: Colors.blue.shade100.withOpacity(0.5)
                ),),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value[i],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:Colors.white.withOpacity(0.9)
                      ),
                      softWrap: true,
                    ),
                    Text(
                      ruleDes.value[i],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.white.withOpacity(0.7)
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            _ruleNameController.text = ruleNames.value[i];
                            _ruleDesController.text = ruleDes.value[i];
                            return Dialog(
                              elevation: 0,
                              backgroundColor: const Color.fromRGBO(46, 55, 86, 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                height: 300,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20,),
                                      const Text(
                                        "Update rule",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _ruleNameController,
                                        decoration: InputDecoration(
                                            hintText: 'Rule name',
                                            hintStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.6),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1)),
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(65, 63, 212, 1), width: 2))
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          decoration: TextDecoration.none,
                                          decorationThickness: 0,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter rule name.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20,),
                                      TextFormField(
                                        controller: _ruleDesController,
                                        decoration: InputDecoration(
                                            hintText: 'Rule description',
                                            hintStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.6),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1)),
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(65, 63, 212, 1), width: 2))
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          decoration: TextDecoration.none,
                                          decorationThickness: 0,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter rule decription.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const Expanded(child: SizedBox(height: 1,)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(153, 162, 232, 1)
                                              ),
                                              backgroundColor: Colors.transparent,
                                            ),
                                            child: const Text(
                                              "Cancel",
                                            ),
                                          ),
                                          const SizedBox(height: 40,),
                                          TextButton(
                                            onPressed: _submitForm,
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(153, 162, 232, 1)
                                              ),
                                              backgroundColor: Colors.transparent,
                                            ),
                                            child: const Text(
                                              "Save",
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.pen, color: Colors.blue, size: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return Dialog(
                              elevation: 0,
                              backgroundColor: const Color.fromRGBO(46, 55, 86, 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Your realy wanna remove rule has rule name \"${value[i]}\"?",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(153, 162, 232, 1)
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          child: const Text(
                                            "Cancel",
                                          ),
                                        ),
                                        const SizedBox(height: 40,),
                                        TextButton(
                                          onPressed: (){
                                            _removeRule(i);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          child: const Text(
                                            "Remove",
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.trash, color: Colors.red, size: 20,
                    ),
                  )
                ],
              )
            ],
          )
      );
    }
    return rs;
  }

  List<Widget> buildListUserChoosed(List<MyUser> users){
    List<Widget> rs = [];
    for(MyUser user in users){
      rs.add(userBrief(user));
    }
    return rs;
  }
  Widget userBrief(MyUser user){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(right: 6, bottom: 4),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(6)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 30,
              width: 30,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FutureBuilder<String?>(
                future: Storage().downloadAvatarURL(user.avatarLink),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text("Error");
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    }
                  } else {
                    return const Center(
                      child: SpinKitPulse(
                        color: Colors.white,
                        size: 10.0,
                      ),
                    );
                  }
                },
              )
          ),
          const SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                user.username,
                style: TextStyle(
                    color: Theme.of(context).dividerColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
          const SizedBox(width: 8,),
          GestureDetector(
            onTap: (){
              List<MyUser> temp = List.from(member.value);
              temp.remove(user);
              member.value = temp;
            },
            child: const Icon(
              CupertinoIcons.xmark,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
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
              "Create community",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async{
                  if (_formCommunitiesNameKey.currentState!.validate()) {
                    if(communitiesImg.value == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 300,
                          behavior: SnackBarBehavior.floating,
                          content: const Text('You need choose communities image.', textAlign: TextAlign.center,),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }else {
                      if(member.value.length<2){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            width: 300,
                            behavior: SnackBarBehavior.floating,
                            content: const Text('You need choose at least 2 people to create a community.', textAlign: TextAlign.center,),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }else {
                        try{
                          String imgLink = await Storage().putImage(communitiesImg.value!, 'group');
                          List<MyUser> temp = member.value;
                          temp.add(GlobalVariable.currentUser!.myUser);
                          Group group = Group(groupIdAsString: '', groupName: _nameController.text, groupOwner: GlobalVariable.currentUser!,
                            rulesName: ruleNames.value, rulesContent: ruleDes.value, createDate: DateTime.now(), review: _desController.text,
                            groupImg: imgLink, groupMembers: temp.map((e) => MyUserWithFollow(myUser: e, numOfFollowed: 0, numOfFollowing:0, isFollow: false)).toList(), isJoined: true);
                          bool success = await DatabaseService().createGroup(group);
                          if(success){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                width: 300,
                                behavior: SnackBarBehavior.floating,
                                content: const Text('Create community successful!', textAlign: TextAlign.center,),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                width: 300,
                                behavior: SnackBarBehavior.floating,
                                content: const Text('Create community failed!', textAlign: TextAlign.center,),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              width: 300,
                              behavior: SnackBarBehavior.floating,
                              content: const Text('An error occurred during community creation.', textAlign: TextAlign.center,),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          print("error: $e");
                        }
                      }
                    }
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent
                ),
                child: const Text(
                  "Create",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async{
                  XFile? image = await ImagePicker().pickImage(
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 100,
                      source: ImageSource.gallery
                  );
                  if(image!=null){
                    communitiesImg.value = image;
                  }
                },
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: communitiesImg,
                        builder: (context, value, child){
                          if(value!= null) {
                            return Container(
                              height: 190,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(value.path)),
                                      fit: BoxFit.cover
                                  )
                              ),
                            );
                          }else {
                            return Container(
                              height: 190,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/group.jpg"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            );
                          }
                        }
                    ),

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
                ),
              ),
              const SizedBox(height: 12,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Communities name",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 15,
                        // fontWeight: FontWeight.w500
                      ),
                    ),
                    Form(
                      key: _formCommunitiesNameKey,
                      child: TextFormField(
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
                            return "Please enter communities name";
                          }
                          return null;
                        },
                        onSaved: (value){
                        },
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      "Review",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 15,
                        // fontWeight: FontWeight.w500
                      ),
                    ),
                    TextFormField(
                      controller: _desController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Members",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15,
                            // fontWeight: FontWeight.w500
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchUserAddInCommunity(userChoosedList: member,)));
                            setState(() {
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable: member,
                        builder: (context, value, child){
                          print("value lenght: ${value.length}");
                          return Wrap(
                            children: buildListUserChoosed(value),
                          );
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rules",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15,
                            // fontWeight: FontWeight.w500
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _ruleNameController.text = '';
                            _ruleDesController.text = '';
                            showDialog(
                                context: context,
                                builder: (context){
                                  return Dialog(
                                    elevation: 0,
                                    backgroundColor: const Color.fromRGBO(46, 55, 86, 1),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      height: 300,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20,),
                                            const Text(
                                              "Add rule",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                              ),
                                            ),
                                            TextFormField(
                                              controller: _ruleNameController,
                                              decoration: InputDecoration(
                                                  hintText: 'Rule name',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white.withOpacity(0.6),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1)),
                                                  focusedBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Color.fromRGBO(65, 63, 212, 1), width: 2))
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                decoration: TextDecoration.none,
                                                decorationThickness: 0,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter rule name.';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20,),
                                            TextFormField(
                                              controller: _ruleDesController,
                                              decoration: InputDecoration(
                                                  hintText: 'Rule description',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white.withOpacity(0.6),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1)),
                                                  focusedBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Color.fromRGBO(65, 63, 212, 1), width: 2))
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                decoration: TextDecoration.none,
                                                decorationThickness: 0,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter rule decription.';
                                                }
                                                return null;
                                              },
                                            ),
                                            const Expanded(child: SizedBox(height: 1,)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(153, 162, 232, 1)
                                                    ),
                                                    backgroundColor: Colors.transparent,
                                                  ),
                                                  child: const Text(
                                                    "Cancel",
                                                  ),
                                                ),
                                                const SizedBox(height: 40,),
                                                TextButton(
                                                  onPressed: _submitForm,
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(153, 162, 232, 1)
                                                    ),
                                                    backgroundColor: Colors.transparent,
                                                  ),
                                                  child: const Text(
                                                    "Add",
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable: ruleNames,
                        builder: (context, value, child){
                          return Column(
                            children: buildRules(value),
                          );
                        }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
