
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/pages/paywall_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class DetaySayfasi extends ConsumerStatefulWidget {
  
  final int itemIndex;

  DetaySayfasi({super.key, this.itemIndex = -1});

  @override
  ConsumerState<DetaySayfasi> createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends ConsumerState<DetaySayfasi> {

  String saveID = "";
  bool isAudioPlay = false;
  bool isSubscribed = false;
  bool _showButton = false;
  late int contenetLenght;
  StringBuffer combineText = StringBuffer();
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkSubscription();
    _initAudio();
    

    var contentList = ref.read(contentProvider);
    contenetLenght = widget.itemIndex < 0 ? contentList.fold(0, (sum, item) => sum + contentList[0].title.length + contentList[0].content.length) : contentList.fold(0, (sum, item) => sum + item.title.length + item.content.length);

    Future.delayed(Duration(milliseconds: contenetLenght), (){
      
      setState(() {
        _showButton = true;
      });
      
    });


    
  }


  


  Future<void> _checkSubscription() async {
    final subscriptionStatus = await SubscriptionManager.isUserSubscribed();
    setState(() {
      isSubscribed = subscriptionStatus;
    });
  }


  Future<void> _initAudio () async {

    await _audioService.initialize();
    _audioService.onStatusChanged = () {
      setState(() {
        //isAudioPlay = false;
      });
    };

    Future.delayed(Duration(milliseconds: 100), () {
      var contentList = ref.read(contentProvider);
      _audioService.setTextfromList(isSubscribed ? contentList : [contentList[0]]);
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioService.dispose();
  }





  @override
  Widget build(BuildContext context) {

    var contentList = ref.watch(contentProvider);
    var image = ref.read(photoTakenProvider);
    var isSave = ref.watch(onSaveProvider);
    var freePhotoTake = ref.watch(saveFreePhotoTakeProvider);
    saveID = ref.read(saveIdProvider);

    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back_ios, size: 36, color: Theme.of(context).iconTheme.color,))
              ),
            )
          ),
          

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

              
                  image != null ? 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Theme.of(context).shadowColor,
                            spreadRadius: 2,
                            blurRadius: 7
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(14),
                        child: Image.file(image, height: 450, width: double.maxFinite, fit: BoxFit.cover,)
                      )
                    ),
                  ) : 
                  CircularProgressIndicator(),

                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isSubscribed ? contentList.length : 1,
                    itemBuilder: (context, index) {
                  
                      var item = contentList[index];

                      

                      /* if (index > 0 && isSubscribed) {
                        return Stack(
                          children: [

                            ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: IgnorePointer(
                                child: Opacity(
                                  opacity: 0.6,
                                  child: ContentModelWidget(title: item.title, content: item.content),
                                ),
                              ),
                            ),

                            ElevatedButton(onPressed: () {}, child: Text("data"))

                          ],
                        );
                      } */

                      return ContentModelWidget(title: item.title, content: item.content);


                    
                    }
                  ),


                  Visibility(
                    visible: !isSubscribed,
                    child: SizedBox(
                      width: 280,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(195, 150, 57, 1)),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PayWallPage())).then((value) {
                            if (value == true) {
                              _checkSubscription();
                            }
                          });
                        }, 
                        child: Text("navigation.moreDetails".tr(), style: Theme.of(context).textTheme.headlineSmall,)
                      ),
                    )
                  ),
            
                  const SizedBox(height: 130,),

                ],
              ),
            ),
          ),


        ],
      ),
      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          audioPlayerline(),

          SizedBox(width: 16,),

          floatingActionButton(isSave, contentList, image)
        
        ],
      )
    
    );
  }



  Future showMesaj (BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
        title: Text("navigation.favoriAlert".tr(), style: Theme.of(context).textTheme.bodyMedium,),
        actions: [
          TextButton(onPressed: (){
      
            ref.read(contentSaveProvider.notifier).removeByContentId(saveID);
            ref.read(onSaveProvider.notifier).state = false;
            print(ref.read(contentSaveProvider));
      
            Navigator.of(context).pop();
          }, child: Text("navigation.yes".tr(), style: Theme.of(context).textTheme.bodySmall,)),
      
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("navigation.no".tr(), style: Theme.of(context).textTheme.bodySmall,))
        ],
      );
      },
      
    );
  }


  Widget audioPlayerline () {
    return Container(
      height: 55,
      //width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [

          IconButton(onPressed: () {

            if (_audioService.isPlaying) {
              _audioService.pause();
            }
            else {
              _audioService.play();
            }
            
          }, icon: _audioService.isPlaying ? Icon(Icons.pause, color: Theme.of(context).iconTheme.color,) : Icon(Icons.play_arrow, color: Theme.of(context).iconTheme.color,)),

          //SizedBox(width: 1,),

          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: Theme.of(context).iconTheme.color,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: Theme.of(context).iconTheme.color,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12)
            ), 
            child: Slider(
              value: _audioService.progress.clamp(0.0, 1.0), 
              onChanged: (value) {
                _audioService.seekTo(value);
              },
              min: 0.0,
              max: 1.0,
            )
          )



        ],
      ),
    );
  }


  Widget floatingActionButton (bool isSave, List<ContentModel> contentList, File? image) {
    return FloatingActionButton(
            onPressed: () {
            
            if (!isSave) {
              saveID = Uuid().v4();
              ref.read(contentSaveProvider.notifier).add(ContentSaveModel(allContent: contentList, imagePath: image!.path, Id: saveID, isSave: true));
              ref.read(onSaveProvider.notifier).state = true;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("navigation.save".tr(), style: Theme.of(context).textTheme.bodyMedium,), backgroundColor: Theme.of(context).cardColor, duration: Duration(milliseconds: 500),));
            }
            else {
              showMesaj(context, ref);
            }
          },
            heroTag: "btn1",
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor, 
            elevation: 6,
            child: Icon(isSave ? Icons.bookmark : Icons.bookmark_outline, color: Theme.of(context).iconTheme.color,),
          );
  }
  


}