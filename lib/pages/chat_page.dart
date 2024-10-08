// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:chat_application/models/chat.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:chat_application/services/media_service.dart';
import 'package:chat_application/services/storage.dart';
import 'package:chat_application/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService authService;
  late DatabaseService databaseService;
  late MediaService mediaService;
  late StorageService storageService;
  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    authService = _getIt.get<AuthService>();
    databaseService = _getIt.get<DatabaseService>();
    mediaService = _getIt.get<MediaService>();
    storageService = _getIt.get<StorageService>();
    currentUser = ChatUser(
      id: authService.user!.uid,
      firstName: authService.user!.displayName,
    );
    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
        stream: databaseService.getChatData(currentUser!.id, otherUser!.id),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];
          if (chat != null && chat.messages != null) {
            messages = _generateChatMessagesList(chat.messages!);
          }
          return DashChat(
            messageOptions: MessageOptions(
              showCurrentUserAvatar: true,
              showTime: true,
            ),
            inputOptions: InputOptions(
              alwaysShowSend: true,
              trailing: [
                _mediaMessageButton(),
              ],
            ),
            currentUser: currentUser!,
            onSend: _sendMessage,
            messages: messages,
          );
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: chatMessage.user.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );
        await databaseService.sendchatMessage( 
          currentUser!.id, 
          otherUser!.id, 
          message
        );
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await databaseService.sendchatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      if(m.messageType==MessageType.Image){
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
        createdAt: m.sentAt!.toDate(),
        medias: [
          ChatMedia(
            url: m.content!, 
            fileName: '', 
            type: MediaType.image,
          )
        ]
        );
      }else{
        return ChatMessage(
        user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
        text: m.content!,
        createdAt: m.sentAt!.toDate(),
      );
      }
      
    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessage;
  }

  Widget _mediaMessageButton() {
    return IconButton(
        onPressed: () async {
          File? file = await mediaService.getImageFromGallery();
          if (file != null) {
            String chatId = generateChatID(
              uid1: currentUser!.id,
              uid2: otherUser!.id,
            );
            String? downloadURL = await storageService.uploadImagetoChat(
              file: file,
              chatID: chatId,
            );
            if (downloadURL != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: downloadURL, fileName: '', type: MediaType.image),
                  ]);
              _sendMessage(chatMessage);
            }
          }
        },
        icon: Icon(
          Icons.image,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
