
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
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkSubscription();
    _initAudio();
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

              
                  //_buildContentSection(contentList),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isSubscribed ? contentList.length : 1,
                    itemBuilder: (context, index) {
                  
                      var item = contentList[index];

                      return Container(
                        child: widget.itemIndex < 0 ? AnimatedContentWidget(title: item.title, content: item.content) : ContentModelWidget(title: item.title, content: item.content),
                      );
                    
                    }
                  ),

                  Visibility(
                    visible: !isSubscribed,
                    child: SizedBox(
                      width: 280,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PayWallPage()));
                        }, 
                        child: Text("More Details", style: Theme.of(context).textTheme.headlineSmall,)
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





  Widget _buildContentSection(List<ContentModel> contentList) {
    if (isSubscribed) {
      // Premium kullanıcı - normal göster
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          var item = contentList[index];
          return widget.itemIndex < 0 
              ? AnimatedContentWidget(title: item.title, content: item.content) 
              : ContentModelWidget(title: item.title, content: item.content);
        }
      );
    } else {
      // Free kullanıcı - blur'lu göster
      return Stack(
        children: [
          // Arka plandaki içerik
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1, // Sadece ilk item
            itemBuilder: (context, index) {
              var item = contentList[index];
              return widget.itemIndex < 0 
                  ? AnimatedContentWidget(title: item.title, content: item.content) 
                  : ContentModelWidget(title: item.title, content: item.content);
            }
          ),
          
          // Blur overlay
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    //child: _buildPremiumPrompt(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  // Premium prompt widget
  Widget _buildPremiumPrompt() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.diamond, size: 64, color: Colors.amber),
          SizedBox(height: 16),
          Text(
            '🔒 Premium Content',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Unlock full historical details\nand unlimited scans',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => PayWallPage()
                )
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, size: 24),
                SizedBox(width: 8),
                Text(
                  'Upgrade Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Text(
              'Only ₺30/month',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}