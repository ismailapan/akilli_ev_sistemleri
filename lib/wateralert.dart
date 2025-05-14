import 'package:flutter/material.dart';
import 'package:udemyapp/flags.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class WaterLakepage extends StatefulWidget {
  const WaterLakepage({super.key});

  @override
  State<WaterLakepage> createState() => _WaterLakePage();
}

class _WaterLakePage extends State<WaterLakepage> {
   bool isWaterLeak = true;
   final AudioPlayer _audioPlayer = AudioPlayer();
   final TextEditingController _passwordcontroller = TextEditingController();

   void _alarmKapat(){
    String sifre = _passwordcontroller.text;

    if(sifre == "1234"){
      stopAlarm();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Şifre doğru, alarm aktif..",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.green, ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ŞİFRE EKSİK YA DA HATALI !!, TEKRAR DENEYİNİZ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.red, ));
    }
   }  

   void playAlarm()async{
    await _audioPlayer.play(AssetSource("sounds/alarm1.mp3"));
   }
   void stopAlarm()async{
    await _audioPlayer.stop();
   }
   void resetButton(){
    final DatabaseReference reference = FirebaseDatabase.instance.ref('sensorverileri/su_kacagi');
    reference.set(0);
   }

   void initState() {
     super.initState();
        final DatabaseReference ref = FirebaseDatabase.instance.ref('sensorverileri/su_kacagi');
        ref.onValue.listen((DatabaseEvent event){
          final dynamic data = event.snapshot.value;

          if(data.toString() == '1'){
            playAlarm();
            setState(() {
              isWaterLeak = true;
            });
          }
          else{
            stopAlarm();
            setState(() {
              isWaterLeak = false;
            });
          }
        });
   }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:  Scaffold(
          backgroundColor: isWaterLeak ? Colors.amber[300] : Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Su Kaçağı Durumu",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            leading: IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Flags(),));
            }, icon: Icon(Icons.arrow_back,size: 35,)),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Icon(
                    isWaterLeak ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                    size: 120,
                    color: isWaterLeak ? Colors.red : Colors.green,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      isWaterLeak ? "DİKKAT ! SU KAÇAĞI TESPİT EDİLDİ" : "SİSTEM GÜVENLİ",
                      style: TextStyle(
                        color: isWaterLeak ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 23
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    SizedBox(height:25,),
                    Text(
                      isWaterLeak ? "Evinizde su kaçağı algılandı. Lütfen tesisatı kontrol edin veya yetkili servise başvurun." 
                      : "Herhangi bir tehlike bulunmamaktadır.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    if(isWaterLeak)...[
                        ElevatedButton.icon(onPressed: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                           title: Text("Alarm Yönetimi",style: TextStyle(fontWeight: FontWeight.bold),),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green) ,)
                        ],
                          ));
            
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Su vanalarını kontrol ediniz!!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                          duration: Duration(seconds:3),
                          backgroundColor: Colors.red,));
                        }, 
                        icon: Icon(Icons.volume_off,color: Colors.white,size: 20,),
                        label:Text("Alarmı Kapat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ), ),
                        SizedBox(height: 15,),
                        ElevatedButton.icon(onPressed: ()async{
                           final Uri phonenumber = Uri.parse("tel:112");
                           await launchUrl(phonenumber, mode: LaunchMode.externalApplication);
                        }, 
                        icon: Icon(Icons.call,color: Colors.white,size: 20,),
                        label:Text("112'yi Ara",style: TextStyle(fontSize:18,color: Colors.white ),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red), ),
                        SizedBox(height: 10,),
                        ElevatedButton.icon(onPressed: resetButton , label:  Icon(Icons.security,color: Colors.white),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),),
                        SizedBox(height: 10,),
                        Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            leading: Icon(Icons.warning_rounded,color: Colors.red,),
                            title: Text("Elektrik bağlantılarını kontrol edin",style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                              "Ana elektrik sigortasını kapatın.\n"
                              "Su ile temas eden priz, kablo varsa kesinlikle müdahale etmeyin."),
                          ),
                        ),
                        Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            leading: Icon(Icons.warning_rounded,color: Colors.red,),
                            title: Text("Ana su vanasını kapatın",style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                              "Evinizdeki ana su giriş vanasını kapatın.\n"
                              "Bu, su sızıntısını durdurur."),
                          ),
                        ),
                        Card(
                          elevation: 7,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            leading: Icon(Icons.warning_rounded,color: Colors.red,),
                            title: Text("Uzman desteği alın",style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                              "Su tesisatçısı veya bina bakım görevlisini arayın."
                              ),
                          ),
                        ),
                    ]
                ],
              ),
            ),
          ),
        )
        
    );
  }
}