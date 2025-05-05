import 'package:flutter/material.dart';
import 'package:udemyapp/firealert.dart';
import 'package:udemyapp/gasalert.dart';
import 'package:udemyapp/movealert.dart';
import 'package:udemyapp/started.dart';
import 'package:udemyapp/wateralert.dart';



class Flags extends StatefulWidget {
  const Flags({super.key});

  @override
  State<Flags> createState() => _nameState();
}
class _nameState extends State<Flags> {
  @override
  Widget build(BuildContext context) {
      double containerheight = MediaQuery.of(context).size.height;
      final h =MediaQuery.of(context).size.height;
      final w =MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red.shade200,
            leading: IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Started()));
            }, icon: Icon(Icons.arrow_back,size: 35,)),
            title: Text("Smart Home App",style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          body: Stack(
            children: [
             Container(
              height: containerheight,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade900,Colors.blue.shade200],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
              ),
             ),
             Align(
              alignment: Alignment.topCenter,
               child: SingleChildScrollView(
                 child: Column(
                  children: [
                    SizedBox(height: h*0.02,),
                    Container(
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GasLeakPage(),));
                    }, icon: Icon(Icons.gas_meter,size: 100,color: Colors.white,)),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 10,
                        color: Colors.black,
                      )
                      ),
                    ),
                    Text("Gaz Alarm Bölümü",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                    SizedBox(height: h*0.001,),
                    Container(
                      child: IconButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FireLakePage()));
                      }, icon: Icon(Icons.fireplace_outlined,size: 100,color: Colors.white,)),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 10,
                        color: Colors.black,
                      )
                      ),
                    ),
                    Text("Yangın Alarm Bölümü",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                    SizedBox(height: h*0.001,),
                    Container(
                       child: IconButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WaterLakepage()));
                       }, icon: Icon(Icons.water_drop_sharp,size: 100,color: Colors.blue[900] ,)),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 10,
                        color: Colors.black,
                      )
                      ),
                    ),
                    Text("Su Alarm Bölümü", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                    SizedBox(height: h*0.001,),
                    Container(
                      child: IconButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoveAlertPage(),));
                      }, icon: Icon(Icons.move_down_rounded,color: Colors.black,size: 100,)),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 10,
                        )
                      ),
                    ),
                    Text("Hareket Algılama",style: TextStyle(fontSize:25,fontWeight: FontWeight.bold ),)
                  ],
                 ),
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}