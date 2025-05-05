import 'package:flutter/material.dart';
import 'package:udemyapp/started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(
        channelKey: 'uyarı kanalı', 
        channelName: 'Uyarı Bildirimleri', 
        channelDescription: 'Sistemden Gelen Acil Uyarıları',
        defaultColor: const Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        channelShowBadge: true,)
    ],
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
void bildirimizni()async{
  if(await Permission.notification.isDenied){
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Started(),
    );
     
  }
}