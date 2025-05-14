import 'package:flutter/material.dart';
import 'package:udemyapp/started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📬 Arka planda mesaj alındı: ${message.notification?.title}');

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'uyarı_kanali',
      title: message.notification?.title ?? 'Uyarı',
      body: message.notification?.body ?? 'Gelen bir bildirim var.',
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await bildirimizni();

  await requestPermission();

  FirebaseMessaging.instance.subscribeToTopic('gaz_kacagi');
  FirebaseMessaging.instance.subscribeToTopic('duman_kacagi');
  FirebaseMessaging.instance.subscribeToTopic('su_kacagi');
  FirebaseMessaging.instance.subscribeToTopic("hareket_kontrol");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'uyarı_kanali',
        channelName: 'Uyarı Bildirimleri',
        channelDescription: 'Sistemden gelen acil uyarılar',
        defaultColor: Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
      ),
    ],
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Uygulama ön plandayken gelen bildirimleri dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Uygulama açıkken gelen mesaj: ${message.notification?.title}");

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          channelKey: 'uyarı_kanali',
          title: message.notification?.title ?? "Uyarı !!",
          body: message.notification?.body ?? "Sistemde tehlike tespit edildi",
          notificationLayout: NotificationLayout.Default,
        ),
      );
    });

    // Kullanıcı bildirime tıkladığında yapılacak işlem
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 Kullanıcı bildirime tıkladı: ${message.notification?.title}");
      // Buraya yönlendirme veya ekran açma işlemi eklenebilir
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Started(),
    );
  }
}

// 🔒 Android 13+ için sistem bildirimi izni
Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('🔓 Bildirim izni verildi');
  } else {
    print('❌ Bildirim izni reddedildi');
  }
}

// 📣 Cihazdan local bildirim izni al (awesome_notifications)
Future<void> bildirimizni() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
