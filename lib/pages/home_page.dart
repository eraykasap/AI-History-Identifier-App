import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/config/data.dart';
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

    


    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10, 
            children: [
              const SizedBox(height: 15),

              topContainer(context),

              const SizedBox(height: 20,),

              castelsList(context),

              //const SizedBox(height: 30,),

              /* ElevatedButton(onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Paywall_2_page()));
              }, child: Text("data")), */

              //Text("BEDEVA FOTOĞRAF HAKKI : $freephototake"),

              Text(ref.watch(saveFreePhotoTakeProvider).toString()),

              Text(ref.watch(savedDayProvider).toString()),

              const SizedBox(height: 30,),

              mapViewMuseum(context),

              const SizedBox(height: 50,),

              identifierCounter(),

              const SizedBox(height: 60,),

            ]
          ),
        ),
      ),
    );
  }

  Widget castelsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text("navigation.kaleler".tr(), style: Theme.of(context).textTheme.headlineLarge,),
        const SizedBox(height: 15),
        SizedBox(
          height: 230,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: historyInfo.length,
            itemBuilder: (context, index) {
              var item = historyInfo[index];

              return GestureDetector(
                onTap: () {
                  showContent(context, item[0], item);
                  //Navigator.of(context).push(CupertinoPageRoute(builder: (context) => StaticContentPage(content: item, imagePath: item[0]),),);
                },
                child: Contentcard(image: item[0], title: item[1]),
              );
            },
          ),
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

              Version.versionCheck();

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


  Future showContent (BuildContext context, String imagePath, List<String> list) async {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return Column(
          children: [
            Dialog(
              backgroundColor: Theme.of(context).cardColor,
              child: Container(
                width: 330,
                height: 600,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
            
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        child: Image.asset(imagePath)
                      ),
                  
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length - 1,
                          itemBuilder: (context, index) {
                          var item = list[index + 1];
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: item == list[1] ? Center(child: Text(item, style:  Theme.of(context).textTheme.headlineLarge)) : Text(item, style:  Theme.of(context).textTheme.bodyMedium),
                          ); 
                        }),
                      )
                  
                    ],
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
          width: 350,
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

}





