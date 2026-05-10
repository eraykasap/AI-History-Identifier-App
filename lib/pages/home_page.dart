import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/pages/articles_details_page.dart';
import 'package:history_identifier/pages/full_map_page.dart';
import 'package:history_identifier/pages/paywall_page.dart';
import 'package:history_identifier/pages/photo_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';




class HomePage extends ConsumerWidget {

  final List<List<String>> historyInfo = [
    StaticContentkalelerList.history_info_1,
    StaticContentkalelerList.history_info_2,
    StaticContentkalelerList.history_info_3,
    StaticContentkalelerList.history_info_4,
    StaticContentkalelerList.history_info_5,
    StaticContentkalelerList.history_info_6,
    StaticContentkalelerList.history_info_7,
    StaticContentkalelerList.history_info_8,
    StaticContentkalelerList.history_info_9,
    StaticContentkalelerList.history_info_10,
  ];

  

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //var freephototake = ref.watch(saveFreePhotoTakeProvider);

    //var nearLocationPlace = ref.watch(nearHistoryPlace);

    var historyEvents = ref.watch(historicalEventsProvider);

    var articlesAsync = ref.watch(wikiArticlesProvider);


    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10, 
            children: [

              const SizedBox(height: 10),

              payWallButton(),

              const SizedBox(height: 10),

              //topContainer(context),

              scannerContainer(context),

              const SizedBox(height: 5,),

              shareContainer(context),

              const SizedBox(height: 20,),

              historicalEventsListt(context, historyEvents),

              const SizedBox(height: 30,),

              //SparkleLoader(),

              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text("navigation.muzeler".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),)
              ),

              mapViewMuseum(context),

              

              //wikiArticlesNews(articlesAsync, context),

              const SizedBox(height: 40,),

            ]
          ),
        ),
      ),
    );
  }


  Widget payWallButton() {

    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        //color: Color.fromRGBO(175, 110, 68, 1),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(175, 110, 68, 1),
            Color.fromRGBO(233, 179, 68, 1)
          ],
          begin: AlignmentGeometry.centerLeft,
          end: AlignmentGeometry.centerRight
        )
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/icon/star.png", scale: 20,),
          SizedBox(width: 10,),
          Text("navigation.premium".tr(), style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
          
        ],

      ),

    );

  }



  Widget historicalEventsListt(BuildContext context, List<HistoricalEvent> historyList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text("navigation.kaleler".tr(), style: Theme.of(context).textTheme.headlineLarge,),
        const SizedBox(height: 15),
        SizedBox(
          height: 230,
          width: MediaQuery.of(context).size.width,
          child: historyList.isNotEmpty ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              var item = historyList[index]; /*historyInfo[index];*/

              return GestureDetector(
                onTap: () {
                  showContent(context, item.imageUrl, item.title, item.text);
                  //Navigator.of(context).push(CupertinoPageRoute(builder: (context) => StaticContentPage(content: item, imagePath: item[0]),),);
                },
                child: WikiEventContentCard(title: item.title, content: item.text, year: item.year.toString()), /*Contentcard(image: item.imageUrl, title: item.title),*/
              );
            },
          ) : SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator(color: Color.fromRGBO(195, 150, 57, 1),))),
        ),
      ],
    );
  }


  Widget topContainer(BuildContext context) {
    return Container(
      height: 135,
      width: MediaQuery.of(context).size.width >= 390 ? 390 : double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 60,
        children: [
          ContainerBTN(
            label: "navigation.share".tr(),
            icon: Icons.share,
            onTop: () async {
              //final params = ShareParams(uri: Uri(path: "https://pub.dev/packages/share_plus"),);
              //SharePlus.instance.share(params);

              //Version.versionCheck();

            },
          ),

          ContainerBTN(
            label: "navigation.premium".tr(),
            icon: Icons.diamond,
            onTop: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PayWallPage()));
            },
          ),

          ContainerBTN(
            label: "navigation.scan".tr(),
            icon: Icons.photo_camera,
            onTop: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PhotoScannerPage()),);
            },
          ),
        ],
      ),
    );
  }


  Widget mapViewMuseum (BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 150)), 
      builder: (context, snapshot) {
        return Stack(
          children: 
          [ 
        
            Container(
              width: MediaQuery.of(context).size.width >= 800 ? 800 : MediaQuery.of(context).size.width * 1,
              height: 240,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 0)
                  )
                ]
              ),
              child: MapViewWidget()
            ),


            Container(
              width: MediaQuery.of(context).size.width >= 800 ? 800 : MediaQuery.of(context).size.width * 1,
              height: 240,
              //color: Colors.amber,
              child: Align(
                alignment: AlignmentGeometry.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryFixed),
                    onPressed: () {
                      //StaticClass.openAllInGoogleMaps();
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => FullMapViewPage()));
                    }, child: 
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("navigation.fullmap".tr(), style: Theme.of(context).textTheme.labelSmall,),
                        const SizedBox(width: 10,),
                        Icon(Icons.open_in_full, color: Theme.of(context).iconTheme.color,)
                      ],
                    )
                  ),
                ),
              ),
            )


          ]

        );
      }
    );
  }


  Future showContent (BuildContext context, String? imagePath, /*List<String> list*/ String? title, String content) async {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return Column(
          children: [
            Dialog(
              backgroundColor: Color.fromRGBO(237, 234, 227, 1),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7, //330,
                height: MediaQuery.of(context).size.height * 0.5, //600,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        if (imagePath != null && imagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            placeholder: (context, url) => const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const SizedBox.shrink(), 
                          ),
                        ),
                                
                        
                    
                        /* Expanded(
                          child: ListView.builder(
                            itemCount: list.length - 1,
                            itemBuilder: (context, index) {
                            var item = list[index + 1];
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: item == list[1] ? Center(child: Text(item, style:  Theme.of(context).textTheme.headlineLarge)) : Text(item, style:  Theme.of(context).textTheme.bodyMedium),
                            ); 
                          }),
                        ), */
                    
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(title ?? "", style: Theme.of(context).textTheme.headlineLarge),
                        ),
                        
                        Text(content, style: Theme.of(context).textTheme.bodyMedium,)
                    
                    
                    
                    
                      ],
                    ),
                  ),
                ),
              )
            ),

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3)
              ),
              child: IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.close, color: Colors.white, size: 40,))
            )

          ],
        );
      }
    );
  }
  

  Widget identifierCounter () {
    return Consumer(
      builder: (context, ref, child) {
        final counter = ref.watch(photoCounterProvider);
        return Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(35),
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 6
              )
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(Icons.photo_camera_outlined, size: 45,),
              Text("navigation.fotografSayacText".tr(), style: TextStyle(fontSize: 22),),
              Text(counter.toString(), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),)
            ],
          )
        );
      }
      
    );
  }


  /* Widget scannerContainer (BuildContext context) {

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(195, 150, 57, 1), width: 2)
      ),

      
      width: MediaQuery.of(context).size.width <= 450 ? 350 : 450,
      height: 130,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        
            Icon(Icons.photo_camera, size: 40, color: Color.fromRGBO(195, 150, 57, 1),),

            SizedBox(width: 25,),
        
            Text("navigation.scan".tr()),
        
            Spacer(),
        
            Image.asset("assets/images/history/statuess.png")
        
          ],
        ),
      ),
    );

  } */


  
  Widget scannerContainer(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PhotoScannerPage()),),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color.fromRGBO(195, 150, 57, 1), width: 2),
        ),
        width: MediaQuery.of(context).size.width <= 450 ? 400 : 450,
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
      
              // Arka plan
              Container(
                color: Colors.white,
                width: double.infinity,
                height: 130,
              ),
      
              // Sol içerik
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Center(
                  child: Row(
                    
                    children: [
                      Icon(Icons.photo_camera, size: 40, color: Color.fromRGBO(195, 150, 57, 1)),
                      SizedBox(width: 25),
                      Text("navigation.scan".tr(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
      
              // Taşan görsel
              Positioned(
                right: 0,
                top: -15,
                child: Image.asset(
                  "assets/images/history/statuess.png",
                  height: 160,
                ),
              ),
      
            ],
          ),
        ),
      ),
    );
  }



  Widget shareContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(195, 150, 57, 1), width: 2),
      ),
      width: MediaQuery.of(context).size.width <= 450 ? 400 : 450,
      height: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [

            // Arka plan
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 130,
            ),

            // Sol içerik
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Row(
                  
                  children: [
                    Icon(Icons.share, size: 40, color: Color.fromRGBO(195, 150, 57, 1)),
                    SizedBox(width: 25),
                    Text("navigation.share".tr(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),

            // Taşan görsel
            Positioned(
              right: 0,
              top: -15,
              child: Image.asset(
                "assets/images/history/share.png",
                height: 160,
              ),
            ),

          ],
        ),
      ),
    );
  }






}





