import 'package:flutter/material.dart';
import 'package:udemyapp/flags.dart';
import 'package:udemyapp/home.dart';

class Started extends StatefulWidget {
  const Started({super.key});

  @override
  State<Started> createState() => _StartedState();
}

class _StartedState extends State<Started> {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SafeArea(
        child: Scaffold(
          
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade900,Colors.orange.shade200],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter 
                    )
                ),
              ),
             Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.home,size: 40,),
                      Text("Smart Home App",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                      Icon(Icons.home, size: 40,)
                    ],
                  ),
                ),
                Container(
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 3,
                      color: Colors.black
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateTime.now().toString().split(" ")[0],style: TextStyle(fontSize: 20,color: Colors.white),)
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 70)),
                Container(
                  width: 250,
                  height: 250,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(),));
                  }, icon: Icon(Icons.home_work_outlined,size: 200,color: Colors.green,)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                      color: Colors.black,
                      width: 8
                    )
                  ),
                ),
                Padding(padding: EdgeInsets.only(top:10 )),
                Text("Başlamak için simgeye tıklayınız",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
              ],
             )
            
            ],
            ),
          ),
        )
        );
  }
}