import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udemyapp/flags.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
final TextEditingController _usernamecontroller = TextEditingController();
final TextEditingController _passwordcontroller = TextEditingController();

 String errorMessage = "";

 void giris_yap(){
  String kullanici_adi = _usernamecontroller.text;
  String sifre = _passwordcontroller.text;

  if(kullanici_adi=="admin"&&sifre=="1234"){
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => Flags(),));
  }
  else{
    showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("Hata",style: TextStyle(color: Colors.white),),
    backgroundColor: Colors.red[400],
    content: Text("KULLANICI ADI VEYA ŞİFRE HATALI!",style: TextStyle(color: Colors.white),),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Tamam",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
    ],
  ),
);

  }
 }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: SafeArea(
       child: Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Smart Home App",style: TextStyle(fontWeight: FontWeight.bold,),),
        ),
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.yellow.shade900,Colors.amber.shade100],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight
                    )
                ),
              ),
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person,size: 100,),

                TextField(
                  controller: _usernamecontroller,
                  decoration: InputDecoration(                   
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Kullanıcı Adı',labelStyle: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  cursorColor: Colors.deepOrange,
                 // maxLength: 11,
                  maxLines: 1,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Şifre',labelStyle: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  cursorColor: Colors.deepOrange,
                  maxLines: 1,
                  obscureText: true,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                ElevatedButton(onPressed:giris_yap,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green) ,
                child: Text("GİRİŞ YAP",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))
              ],
            ),
            ],
            
          ),
        ),
       ),
     ),
    );
  }
}