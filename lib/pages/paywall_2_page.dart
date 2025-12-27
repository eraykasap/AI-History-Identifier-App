
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paywall_2_page extends StatefulWidget {
  const Paywall_2_page({super.key});

  @override
  State<Paywall_2_page> createState() => _Paywall_2State();
}

class _Paywall_2State extends State<Paywall_2_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 27, 33, 1),
      body: Column(
        children: [

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back_ios, size: 28, color: Colors.white,))
              ),
            )
          ),


          Text("Tek seferlik teklif", 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 32, 
              fontWeight: FontWeight.w800
            ),
          ),

          Text("Bunu bir daha asla göremeyeceksin",
            style: TextStyle(
              color: Colors.white
            ),
          ),

          SizedBox(height: 80,),

          offersContainer()


        ],
      )
    );
  }


  Widget offersContainer () {

    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text("%50 İndirim", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(15, 27, 33, 1),
                borderRadius: BorderRadius.circular(12)
              ),
            ),
          )

        ],
      ),
    );

  }


}