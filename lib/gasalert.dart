import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
final TextEditingController _passwordcontroller = TextEditingController();
  void alarmKapat(){
    String sifre = _passwordcontroller.text;

    if(sifre == "1234"){
      stopAlarm();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şifre doğrulandı, alarm aktif",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ŞİFRE BİLGİSİ YANLIŞ, TEKRAR DENEYİNİZ !",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,));
    }
  }
  
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
    void setupFirebaseMessaging(){
      FirebaseMessaging.instance.getToken().then((token){
      print("cihaz tokeni: $token");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print(" Uygulama açıkken bildirim: ${message.notification?.title}");
    });
    }
    bildirimizni();
    final DatabaseReference ref = FirebaseDatabase.instance.ref('sensorverileri/gaz_kacagi');
    
    ref.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;

      if (data.toString() == '1') {
       // bildirimgonder();
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
                    showDialog(context: context, builder: (context)=>AlertDialog(
                      title: Text("Alarm Yönetimi"),
                      backgroundColor: Colors.white,
                      content: TextField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        labelText: 'Şifre',labelStyle: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  cursorColor: Colors.deepOrange,
                  maxLines: 1,
                  obscureText: true,
                      ),
                      actions: [
                        ElevatedButton(onPressed: alarmKapat, child: Text("Alarm Kapat"))
                      ],
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("!! Gaz kaçağı durumu devam ediyor olabilir. Kontrol ediniz...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                           duration: Duration(seconds: 3),
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
                ElevatedButton.icon(onPressed: (){
                  showDialog(context: context, builder: (context)=> AlertDialog(
                    title: Text("Acil Durum Bildirimleri",style: TextStyle(fontWeight: FontWeight.bold),),
                    backgroundColor: Colors.red[400],
                    content: Row(
                      children: [
                        ElevatedButton.icon(onPressed: ()async{
                          final Uri phonenumber = Uri.parse("tel:112");
                          await launchUrl(phonenumber, mode: LaunchMode.externalApplication);
                        }, label: Text("ARA 112",style: TextStyle(color: Colors.white),),icon: Icon(Icons.call,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.green),),
                        ElevatedButton.icon(onPressed: ()async{
                          final Uri phonenumber = Uri.parse("tel:187");
                          await launchUrl(phonenumber, mode: LaunchMode.externalApplication);
                        }, label: Text("ARA 187",style: TextStyle(color: Colors.white),),icon: Icon(Icons.call,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.green),),
                      ],
                    ),
                  ));
                }, label: Icon(Icons.phone,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),),
                SizedBox(height: 15),
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
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        showModalBottomSheet(context: context, isScrollControlled: true ,builder: (BuildContext context){
        return SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
             Icon(Icons.gas_meter, size: 50, color: Colors.orange),
                SizedBox(height: 10),
                Text(
                  "Gaz Kaçağı Anında Yapılacaklar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  "✅ Gaz vanasını hemen kapatın.\n\n"
                  "✅ Elektrik düğmelerine ve açık alevlere dokunmayın.\n\n"
                  "✅ Kapı ve pencereleri açarak evi havalandırın.\n\n"
                  "✅ Binayı derhal terk edin.\n\n"
                  "✅ Güvenli mesafeden 187 Doğalgaz Acil hattını arayın.\n\n"
                  "✅ Diğer bina sakinlerini bilgilendirin.",
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Kapat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ) 
            ]
          ),),
        );

        });
      }, icon: Icon(Icons.add,color: Colors.black,),label:Text("Acil Durumlar",style: TextStyle(color: Colors.black),) )
    );
  }
}
