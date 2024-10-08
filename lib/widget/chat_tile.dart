import 'package:chat_application/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function ontap;
  const ChatTile({super.key, required this.userProfile, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        ontap();
      },
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          userProfile.pfpURL!,
        ),
      ),
      title: Text(userProfile.name!),

    );
  }
}
