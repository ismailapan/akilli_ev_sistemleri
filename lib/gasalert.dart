import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:udemyapp/flags.dart';
import 'package:udemyapp/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';


class GasLeakPage extends StatefulWidget {
  
  @override
  
  State<GasLeakPage> createState() => _GasLeakPageState();
}

class _GasLeakPageState extends State<GasLeakPage> {
  
  bool isGasLeaking = false; 
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  void bildirimgonder(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(id: 1, channelKey: 'uyarı_kanali',
      title: 'Gaz Kaçağı Tespit Edildi!',
      body: 'Lütfen ortamı havalandırın.',
      notificationLayout: NotificationLayout.Default,)
    );
  }

  void resetGasLeak(){
    final DatabaseReference reference = FirebaseDatabase.instance.ref('sensorverileri/gaz_kacagi');
    reference.set(0);
  }
  
  void playAlarm()async{
    await _audioPlayer.play(AssetSource("sounds/alarm1.mp3"));
  }
  void stopAlarm()async{
    await _audioPlayer.stop();
  }
  void initState (){
    super.initState();
    bildirimizni();
    final DatabaseReference ref = FirebaseDatabase.instance.ref('sensorverileri/gaz_kacagi');
    
    ref.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;

      if (data.toString() == '1') {
        bildirimgonder();
        playAlarm();
        setState(() {
          isGasLeaking = true;
        });
      } else {
        stopAlarm();
        setState(() {
          isGasLeaking = false;
        });
      }
    });
  }

  
  
  Widget build(BuildContext context) {
    final ekranYukseklik = MediaQuery.of(context).size.height;
    final ekranGenislik = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, 
      leading: IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => Flags(),));}, icon: Icon(Icons.arrow_back,size: 35,)),
      title: Text("Gaz Kaçağı Durumu",style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.red),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // İkon ve Uyarı Mesajı
              Icon(
                isGasLeaking ? Icons.warning_amber_rounded : Icons.check_circle,
                color: isGasLeaking ? Colors.red : Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                isGasLeaking ? "DİKKAT! GAZ KAÇAĞI TESPİT EDİLDİ" : "Sistem Güvenli",
                style: TextStyle(
                  fontSize: ekranGenislik*0.05,
                  fontWeight: FontWeight.bold,
                  color: isGasLeaking ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: ekranYukseklik*0.02),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isGasLeaking
                      ? "Lütfen camları açın, ateş yakmayın ve yetkililere haber verin."
                      : "Şu anda herhangi bir gaz kaçağı tespit edilmedi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 30),
          
              if (isGasLeaking) ...[
                ElevatedButton.icon(
                  onPressed: (){
                    stopAlarm();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("!! Gaz kaçağı durumu devam ediyor olabilir. Kontrol ediniz...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                           duration: Duration(seconds: 5),
                          backgroundColor: Colors.deepOrange[900],));
                  },
                  icon: Icon(Icons.volume_off),
                  label: Text("Alarmı Kapat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: ()async{
                    final Uri phonenumber = Uri.parse("tel:112");
                    await launchUrl(phonenumber, mode: LaunchMode.externalApplication);
                  },
                  icon: Icon(Icons.call),
                  label: Text("112'yi Ara"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15,),
                ElevatedButton.icon(onPressed: resetGasLeak, label: Icon(Icons.security,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
              ] else ...[
                Text(
                  "Şu anda herhangi bir tehlike yok.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
