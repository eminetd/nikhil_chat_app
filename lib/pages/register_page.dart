// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'package:chat_application/const/const.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/alert_service.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:chat_application/services/media_service.dart';
import 'package:chat_application/services/navigation_service.dart';
import 'package:chat_application/services/storage.dart';
import 'package:chat_application/widget/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt getIt = GetIt.instance;
  final GlobalKey<FormState> rFormKey = GlobalKey();

  late MediaService mediaService;
  File? selectedImage;
  bool isloading = false;
  String? email, password, name;
  late AuthService authService;
  late NavigationService navigationService;
  late AlertService alertService;
  late StorageService storageService; 
  late DatabaseService databaseService;
  @override
  void initState() {
    super.initState();
    mediaService = getIt.get<MediaService>();
    authService = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
    storageService = getIt.get<StorageService>();
    databaseService = getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [
          _headerText(),
          if (!isloading) registerForm(),
          if (!isloading) loginAccLink(),
          if (isloading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign UP',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }

  Widget registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: rFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            photoselect(),
            CustomForm(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hinttext: 'Name',
              validationsRegx: NAME_VALIDATION_REGEX,
              onsaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomForm(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hinttext: 'Email',
              validationsRegx: EMAIL_VALIDATION_REGEX,
              onsaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomForm(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hinttext: 'Password',
              validationsRegx: PASSWORD_VALIDATION_REGEX,
              obsecuretext: true,
              onsaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            rButton(),
          ],
        ),
      ),
    );
  }

  Widget photoselect() {
    return GestureDetector(
      onTap: () async {
        File? file = await mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget rButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            setState(() {
              isloading = true;
            });
            try {
              if ((rFormKey.currentState?.validate() ?? false) &&
                  selectedImage != null) {
                rFormKey.currentState?.save();
                bool result = await authService.signIn(email!, password!);
                if (result) {
                  // print(result);
                  String? pfpUrl = await storageService.uploadUserpfp(
                    file: selectedImage!, 
                    uid: authService.user!.uid,
                    );
                    if(pfpUrl!=null){
                      await databaseService.createUserProfile(
                        userProfile: UserProfile(
                          uid: authService.user!.uid, 
                          name: name, 
                          pfpURL: pfpUrl,
                          )
                        );
                       alertService.showToast(
                        text: 'User Registered Succesfully',
                        icon:Icons.check
                      ); 
                      navigationService.goBack();
                      navigationService.pushreplacementnamed('/home');
                    }else{
                      throw Exception('Unable to register User');
                    }
                }else{
                  throw Exception("Unable to register");
                }
              }
            } catch (e) {
              // print(e);
                alertService.showToast(
                        text: 'Failed to register User',
                        icon:Icons.error
                      ); 
            }
            setState(() {
              isloading = false;
            });
          }),
    );
  }

  Widget loginAccLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Already have an Accout? "),
        GestureDetector(
          onTap: () {
            navigationService.goBack();
          },
          child: Text(
            "Log In",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }
}
