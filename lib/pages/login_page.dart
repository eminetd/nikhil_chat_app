// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_application/const/const.dart';
import 'package:chat_application/services/alert_service.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/services/navigation_service.dart';
import 'package:chat_application/widget/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final GetIt getIt = GetIt.instance;
final GlobalKey<FormState> loginFormKey = GlobalKey();
late  AuthService authService;
late NavigationService navigationService;
late AlertService alertService;
String? email, password;


class _LoginPageState extends State<LoginPage> {
    bool isloading =  false;

  @override
  void initState() {
    super.initState();
    authService = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
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
          SizedBox(height: 20,),
          _headerText(), loginForm()],
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
            'welcome',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              loginButton(),
              createAccLink(),
            ],
          )),
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
              setState(() {
              isloading=true;
            });
            if (loginFormKey.currentState?.validate() ?? false) {
              loginFormKey.currentState?.save();
              bool result = await authService.login(email!, password!);
              // print(result);
              if (result) {
                navigationService.pushreplacementnamed('/home');
              } else {
                alertService.showToast(
                    text: "Failed to Login Please try again !",
                    icon: Icons.error);
              }
            }
              setState(() {
              isloading=false;
            });
          }),
    );
  }

  Widget createAccLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Dont't have an Accout? "),
        GestureDetector(
          onTap: () {
            navigationService.pushNamed('/register');
          },
          child: Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }
}
