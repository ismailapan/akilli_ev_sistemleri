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
  final TextEditingController _passwordcontroller = TextEditingController();

  void _alarmKapat(){
    String sifre = _passwordcontroller.text;

    if(sifre == "1234"){
      stopAlarm();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: 
        Text("Şifre doğrulandı, alarm aktif",style: TextStyle(fontWeight: FontWeight.bold),),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: 
        Text("ŞİFRE EKSİK YA DA HATALI!!, TEKRAR DENEYİNİZ",style: TextStyle(fontWeight: FontWeight.bold),),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,));
    }
  }

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
                    showDialog(context: context, builder: (context)=>AlertDialog(
                       title: Text("Alarm Yönetimi"),
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
                        ElevatedButton(onPressed: (){
                          _alarmKapat();
                          Navigator.of(context).pop();
                        }, child: Text("Alarmı Kapat",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
                      ],
                       
                    ));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("!! Yangın riski devam ediyor olabilir. Kontrol ediniz..",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                    duration: Duration(seconds: 3),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),),
                  
                ]
               ],
            )
            ),
            floatingActionButton: FloatingActionButton.extended(onPressed:(){
              showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 50, color: Colors.red),
                SizedBox(height: 10),
                Text(
                  "Yangın Anında Yapılacaklar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  "✅ Sakin kalın.\n\n"
                  "✅ Acil çıkışlara yönelin.\n\n"
                  "✅ Asansör kullanmayın.\n\n"
                  "✅ Ağız/burun kapatın.\n\n"
                  "✅ Binayı terk edin.",
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Kapat",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
      );
            }, 
            icon: Icon(Icons.add,color: Colors.white,) ,
            label: Text("Yangın Talimatları",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            backgroundColor: Colors.blue[400],),
        )
      
    );
  }
}