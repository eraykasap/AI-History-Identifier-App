
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/main.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/pages/detay_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:lottie/lottie.dart';


class PhotoAIanalizPage extends ConsumerStatefulWidget {

  final File Myimage;

  PhotoAIanalizPage({
    super.key,
    required this.Myimage
  });

  @override
  ConsumerState<PhotoAIanalizPage> createState() => _PhotoAIanalizPageState();
}

class _PhotoAIanalizPageState extends ConsumerState<PhotoAIanalizPage> with TickerProviderStateMixin {

  String result = "";
  bool analizEdiliyor = true;
  AnimationController? _lottieController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _startAnalysis();

    Future.microtask(() {
      ref.read(photoTakenProvider.notifier).state = widget.Myimage;

      ref.read(photoCounterProvider.notifier).state++;
    });

  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: Stack(
        children: [ 
          Center(
            child: AspectRatio(
              aspectRatio: 9/16,
              child:Image.file(widget.Myimage)
               /*ClipRect(child: Image.file(widget.Myimage, fit: BoxFit.cover,))*/
            ),
          ),


          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.black.withAlpha(150),
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                //color: Colors.amber,
                child: LottieBuilder.asset(
                  "assets/animations/Sparkles Loop Loader ai.json",
                  repeat: true,
                ),
              ),
            ),
          )

        ]
      ),
    );

  }


  Future<void> _startAnalysis () async {

    try {
      List<ContentModel> icerikListesi = [];
      icerikListesi = await ref.read(apiOperationsController).sendImageAndGetJson(widget.Myimage);
      if (icerikListesi.isNotEmpty) {
        ref.read(contentProvider.notifier).state = icerikListesi;
        ref.read(onSaveProvider.notifier).state = false;
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => DetaySayfasi()));
      }
      else {
        //print("--------- LİSTE HATASI ---------");
        setState(() {
          analizEdiliyor = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2), content: Text("navigation.analiz_error".tr()))).closed.then((_) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MyApp()));
        });
        
      }
    } catch (e) {
      //print("--------- CACHE HATASI ---------");
      setState(() {
        analizEdiliyor = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2), content: Text("navigation.analiz_error".tr()))).closed.then((_) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MyApp()));
      });
      
    }

  }


}