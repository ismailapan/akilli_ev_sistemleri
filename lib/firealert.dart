import 'package:flutter/material.dart';
import 'package:udemyapp/flags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';

class FireLakePage extends StatefulWidget {

  const FireLakePage({super.key});

  @override
  State<FireLakePage> createState() => _FireLakePageState();
}

class _FireLakePageState extends State<FireLakePage> {
  bool isFireLeaking =false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void resetGasLeak(){
    final DatabaseReference ref = FirebaseDatabase.instance.ref("sensorverileri/duman_kacagi");
    ref.set(0);
  }

  void playAlarm()async{
    await _audioPlayer.play(AssetSource("sounds/alarm1.mp3"));
  }

  void stopAlarm()async{
    await _audioPlayer.stop();
  }
  void initState() {
    super.initState();
    final DatabaseReference ref = FirebaseDatabase.instance.ref("sensorverileri/duman_kacagi");

    ref.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;

      if (data.toString() == '1') {
        playAlarm();
        setState(() {
          isFireLeaking = true;
        });
      } else {
        stopAlarm();
        setState(() {
          isFireLeaking = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: isFireLeaking ? Colors.deepOrange.shade100 : Colors.limeAccent,
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("Yangın Kontrol",style: TextStyle(fontWeight: FontWeight.bold),),
            leading: IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context) => Flags(),));
            }, icon: Icon(Icons.arrow_back)),
          ),
          body: Center(
            child: Column(
               children: [
                Padding(padding: EdgeInsets.only(top:80)),
                Icon(isFireLeaking ? Icons.warning_amber_rounded : Icons.check_circle,
                color: isFireLeaking ? Colors.red : Colors.green,
                size: 130),
                SizedBox(height: 20,),
                Text(
                  isFireLeaking ? "DİKKAT !! YANGIN TESPİT EDİLDİ" : "Sistem Güvenli.",
              
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,
                  color: isFireLeaking ? Colors.red : Colors.green),

                ),
                SizedBox(height: 15,),
                Text(
                  isFireLeaking ? "Lütfen acil çıkışları kullanarak binayı terk edin." : "Yangın tehlikesi yok.",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isFireLeaking ? "En yakın çıkış kapısına yönelin" : "Yangın tespit edilmedi",
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                    ),
                    Icon(isFireLeaking ? Icons.exit_to_app_rounded : Icons.security,
                    color: isFireLeaking ? Colors.green : Colors.blue,)
                  ],
                ),
                SizedBox(height: 15,),
                if(isFireLeaking)...[
                  ElevatedButton.icon(onPressed: ()async{
                    final Uri phonenumber = Uri.parse("tel:112");
                    await launchUrl(phonenumber,mode: LaunchMode.externalApplication);
                  }, 
                  label: Text("112 ACİL",style: TextStyle(color: Colors.black),),
                  icon: Icon(Icons.call,color: Colors.black,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))
                  ),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(onPressed: (){
                    stopAlarm();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("!! Yangın aktif olabilir. Kontrol ediniz..",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                    duration: Duration(seconds: 10),
                    backgroundColor: Colors.white,));
                  }, 
                  label: Text("Alarmı Kapat",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  icon: Icon(Icons.volume_off,color: Colors.black,), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))
                  ),

                  ),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(onPressed: resetGasLeak, label:
                  Icon(Icons.security,color: Colors.white,),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
                ]
               ],
            )
            ),
        ),
      
    );
  }
}