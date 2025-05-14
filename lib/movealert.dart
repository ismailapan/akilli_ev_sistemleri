import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:udemyapp/flags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';

class MoveAlertPage extends StatefulWidget {
  
  const MoveAlertPage({super.key});


  @override
  State<MoveAlertPage> createState() => _MoveAlertPage();
}

class _MoveAlertPage extends State<MoveAlertPage> {
bool isMoveAlert =true;
final AudioPlayer audioPlayer = AudioPlayer();
double _iconOpacity = 1.0;
late Timer _blinktimer;
final TextEditingController _passwordcontroller = TextEditingController();

void _alarmKapat(){
  String sifre = _passwordcontroller.text;
  if(sifre == "1234"){
    _stopalarm();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Şifre doğru, alarm aktif",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      duration:Duration(seconds: 3),
      backgroundColor: Colors.green,));
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("ŞİFRE HATALI YA DA EKSİK!!, TEKRAR DENEYİNİZ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      duration:Duration(seconds: 3),
      backgroundColor: Colors.red,));
  }
}

void _resetmovealert(){
  final DatabaseReference reference = FirebaseDatabase.instance.ref('sensorverileri/hareket_kontrol');
  reference.set(0);
}

void _playalarm()async{
 await audioPlayer.play(AssetSource("sounds/alarm1.mp3")); 
}
void _stopalarm()async{
  await audioPlayer.stop();
}

void initState() {
  super.initState();
  final DatabaseReference ref = FirebaseDatabase.instance.ref('sensorverileri/hareket_kontrol');
  ref.onValue.listen((DatabaseEvent event){
    final dynamic data = event.snapshot.value;
    if(data.toString()=='1'){
      _playalarm();
      setState(() {
        isMoveAlert=true;
      });
    }
    else{
      _stopalarm();
      setState(() {
        isMoveAlert=false;
      });
    }
  });
   _blinktimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
    if (mounted && isMoveAlert) {
      setState(() {
        _iconOpacity = _iconOpacity == 1.0 ? 0.0 : 1.0;
      });
    }
  });
  
}
void dispose(){
  _blinktimer.cancel();
  super.dispose();
}


@override  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text("Hareket Algılama",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
      leading: IconButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Flags(),));
      }, icon: Icon(Icons.arrow_back,size: 27,)),
     ),
     body: Center(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          Icon(
            isMoveAlert  ? Icons.security_update_warning_outlined : Icons.security_update_good_outlined,
            size: 100,
            color: 
            isMoveAlert ? Colors.red : Colors.green,),
          SizedBox(height:10 ,),
          Text( isMoveAlert ?"Şüpheli Hareket Tespiti" : "Hareket Tespit Edilmedi",
          style: TextStyle(fontSize: 18),),
          Text( isMoveAlert ? "SİSTEM : TEHLİKE ALGILANDI !!" : "GİRİŞ BÖLÜMÜ GÜVENLİ",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          SizedBox(height:25),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security,size: 45,
              color: isMoveAlert ? Colors.grey : Colors.green ,),
              Text( ": SİSTEM GÜVENLİ ",
              style: TextStyle(fontSize: 15,
              fontWeight: isMoveAlert ? FontWeight.normal : FontWeight.bold,
              color: isMoveAlert ? Colors.grey : Colors.green)),
            ],
           ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security,size: 45,
              color: isMoveAlert ? Colors.red : Colors.grey ),
              Text(": YABANCI CİSİM UYARISI !!",
              style: TextStyle(fontSize: 15,
              fontWeight: isMoveAlert ? FontWeight.bold : FontWeight.normal,
              color: isMoveAlert ? Colors.red : Colors.grey),)
            ],
           ),
           SizedBox(height: 25,),
           if(isMoveAlert)...[
            AnimatedOpacity(
              opacity: _iconOpacity, 
              duration: Duration(milliseconds: 400),
              child:Icon(Icons.warning_rounded,color: Colors.red,size: 85),
              ),
             Text("DİKKAT !!",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30,color: Colors.red),),
             Text("Acil çıkışları kontrol ediniz..",style: TextStyle(fontSize: 20),),
             SizedBox(height: 10,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: ()async{
              final Uri phonenumber = Uri.parse("tel:112");
              await launchUrl(phonenumber,mode: LaunchMode.externalApplication);
             },
             label: Text("112 ARA",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),icon: Icon(Icons.call,color: Colors.black,),
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              )),
              SizedBox(width: 15,),
              ElevatedButton.icon(onPressed: (){
                showDialog(context: context, builder: (context)=> AlertDialog(
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
                
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şüpheli hareket algılandı,acil durumu bildiriniz.",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),backgroundColor: Colors.red,
                duration: Duration(seconds: 3),));
              }, label: Text("Alarmı Kapat",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
              icon: Icon(Icons.volume_off_outlined,color: Colors.white,),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
              ],
             ),
             SizedBox(height: 15,),
             ElevatedButton.icon(onPressed: _resetmovealert, label: Icon(Icons.security,color: Colors.white,),style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),)
            ]
        ],
      ),
     ),
    );
  }
}