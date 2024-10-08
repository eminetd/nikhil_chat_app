import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/services/alert_service.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:chat_application/services/media_service.dart';
import 'package:chat_application/services/navigation_service.dart';
import 'package:chat_application/services/storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerService() async {
  final GetIt getit = GetIt.instance;
  getit.registerSingleton<AuthService>(AuthService());
  getit.registerSingleton<NavigationService>(NavigationService());
  getit.registerSingleton<AlertService>(AlertService());
  getit.registerSingleton<MediaService>(MediaService());
  getit.registerSingleton<StorageService>(StorageService());
  getit.registerSingleton<DatabaseService>(DatabaseService());
}

String generateChatID({required String uid1,required String uid2}){
  List uids = [uid1,uid2];
  uids.sort();
  String chatID = uids.fold("",(id,uid)=>"$id$uid");
  return chatID;
}
 