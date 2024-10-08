// ignore_for_file: prefer_const_constructors

import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/pages/chat_page.dart';
import 'package:chat_application/services/alert_service.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:chat_application/services/navigation_service.dart';
import 'package:chat_application/widget/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.instance;
  late AuthService authservice;
  late NavigationService navigationService;
  late AlertService alertService;
  late DatabaseService databaseService;

  @override
  void initState() {
    super.initState();
    authservice = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();
    alertService = getIt.get<AlertService>();
    databaseService = getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await authservice.logout();
                if (result) {
                  alertService.showToast(
                      text: 'Succesfully logged out', icon: Icons.check);
                  navigationService.pushreplacementnamed('/login');
                }
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: databaseService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              // child: Text('Unable to load Data'),
              );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              return ChatTile(
                  userProfile: user,
                  ontap: () async {
                    final chatExists = await databaseService.checkchatExists(
                      authservice.user!.uid,
                      user.uid!,
                    );
                    // print(chatExists);
                    if (!chatExists) {
                      await databaseService.createNewChat(
                        authservice.user!.uid,
                        user.uid!,
                      );
                    }
                    navigationService.push(MaterialPageRoute(builder: (context){
                      return ChatPage(chatUser: user);
                    }));
                  });
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
