
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/pages/detay_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:latlong2/latlong.dart' show LatLng;



class ContentModelWidget extends StatelessWidget {

  //final File takenImage;
  final String title;
  final String content;

  ContentModelWidget({
    super.key,
    //required this.takenImage,
    required this.title,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SelectionArea(
        child: Column(
          children: [
            //Image.file(takenImage),
            SizedBox(height: 10,),
            Center(child: Container(child: Text(title, style: Theme.of(context).textTheme.headlineLarge,))),
            SizedBox(height: 10,),
            Center(child: Text(content, style: Theme.of(context).textTheme.bodyMedium,)),
            SizedBox(height: 35,)
          ],
        ),
      ),
    );
  }
  
}


class ContentSavedCard extends StatelessWidget {

  final File image;
  final List<ContentModel> allContent;

  const ContentSavedCard({
    super.key,
    required this.image,
    required this.allContent
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.blue,
                ),
                width: double.maxFinite,
                height: 160,
                child: Image.file(image, fit: BoxFit.cover,),
              ),
            ),
            //SizedBox(height: 10,),
            //
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Text(allContent[0].title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis,),
            )

          ],
        ),
      )
    );
  }
}


class Contentcard extends StatelessWidget {

  final String image;
  final String title;
  

  const Contentcard({
    super.key,
    required this.image,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.blue
                  ),
                  width: double.maxFinite,
                  height: 160,
                  child: Image.asset(image, fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: 10,),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis,),
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}


class ContainerBTN extends StatelessWidget {

  final String label;
  final IconData icon;
  final VoidCallback onTop;

  const ContainerBTN({
    required this.label,
    required this.icon,
    required this.onTop,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTop(),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Color.fromRGBO(195, 150, 57, 1) /*Theme.of(context).canvasColor*/,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primaryFixed, size: 38,),
          ),
        ),
        SizedBox(height: 5,),
        Text(label, style: Theme.of(context).textTheme.labelSmall,)
      ],
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {


  final List<ContentSaveModel> allContent;

  CustomSearchDelegate(this.allContent);
  
  ThemeData appBarTheme (BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.labelMedium,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).canvasColor, width: 2), // Odaklandığında
        
        ),
        
      ),
      textSelectionTheme: TextSelectionThemeData(
      cursorColor: Theme.of(context).canvasColor, // İmleç rengi
      
    ),
    );
    
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [
      IconButton(onPressed: () {
        query.isEmpty ? null : query = "";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    
    return IconButton(onPressed: () {
      close(context, null);
    }, icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color, fontWeight: FontWeight.bold,));
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    
    final suggestions = allContent.where((item) => item.allContent[0].title.toLowerCase().contains(query.toLowerCase())).toList();
    return Consumer(
      
      builder: (context, ref, child) {
        return GridView.builder(
          itemCount: suggestions.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85
        ), itemBuilder: (context, index) {
          
          final item = suggestions[index];
          return GestureDetector(
            onTap: () {
              ref.read(contentProvider.notifier).state = item.allContent;
              ref.read(photoTakenProvider.notifier).state = item.image;
              ref.read(onSaveProvider.notifier).state = item.isSave;
              ref.read(saveIdProvider.notifier).state = item.Id;
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => DetaySayfasi()));
            },
            child: ContentSavedCard(image: item.image, allContent: item.allContent)
          );
        });
      },
      
    );
  }
  
}


class StaticContentkalelerList {

  static final List<String> history_info_1 = [
    "history_info_1.conntent_0".tr(),
    "history_info_1.conntent_1".tr(),
    "history_info_1.conntent_2".tr(),
  ];

  static final List<String> history_info_2 = [
    "history_info_2.conntent_0".tr(),
    "history_info_2.conntent_1".tr(),
    "history_info_2.conntent_2".tr(),
  ];

  static final List<String> history_info_3 = [
    "history_info_3.conntent_0".tr(),
    "history_info_3.conntent_1".tr(),
    "history_info_3.conntent_2".tr(),
  ];

  static final List<String> history_info_4 = [
    "history_info_4.conntent_0".tr(),
    "history_info_4.conntent_1".tr(),
    "history_info_4.conntent_2".tr(),
  ];

  static final List<String> history_info_5 = [
    "history_info_5.conntent_0".tr(),
    "history_info_5.conntent_1".tr(),
    "history_info_5.conntent_2".tr(),
  ];

  static final List<String> history_info_6 = [
    "history_info_6.conntent_0".tr(),
    "history_info_6.conntent_1".tr(),
    "history_info_6.conntent_2".tr(),
  ];

  static final List<String> history_info_7 = [
    "history_info_7.conntent_0".tr(),
    "history_info_7.conntent_1".tr(),
    "history_info_7.conntent_2".tr(),
  ];

  static final List<String> history_info_8 = [
    "history_info_8.conntent_0".tr(),
    "history_info_8.conntent_1".tr(),
    "history_info_8.conntent_2".tr(),
  ];

  static final List<String> history_info_9 = [
    "history_info_9.conntent_0".tr(),
    "history_info_9.conntent_1".tr(),
    "history_info_9.conntent_2".tr(),
  ];

  static final List<String> history_info_10 = [
    "history_info_10.conntent_0".tr(),
    "history_info_10.conntent_1".tr(),
    "history_info_10.conntent_2".tr(),
  ];
  
}


class MapViewWidget extends StatelessWidget {
  MapViewWidget({super.key});

  
  var place = StaticClass.place;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialZoom: 3,
        initialCenter: LatLng(41.0115, 28.9833),
      
      ),
      children: [
      TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: "com.example.history_identifier",
      ),
            
    
      MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 40,

          //disableClusteringAtZoom: 50,
          //spiderfyCircleRadius: 1,
          //spiderfySpiralDistanceMultiplier: 1,
          size: Size(30, 30),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50),
          maxZoom: 20,
          builder: (context, markers) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(195, 150, 57, 1),
                border: Border.all(width: 2, color: Colors.transparent)
              ),
              child: Center(
                child: Text(
                  markers.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            );
          },
          
          
          markers: place.map((place) {
            return Marker(
              point: LatLng(place.lat, place.lang), 
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => StaticClass.showPlaceOptions(context, place),
                child: Icon(Icons.location_on, color: Colors.red, size: 40,)
              )
            );
          }).toList()
          
          
        )
      
      )
          
          
      ]
    );
  }
}


class ContainerPayyWall extends StatelessWidget {
  

  final IconData icon;
  final String label;

  ContainerPayyWall({
    super.key,
    required this.icon,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      //height: 110,
      decoration: BoxDecoration(
        color: Color.fromRGBO(25, 43, 51, 1),
        border: Border.all(color: Colors.blue.withAlpha(100), width: 1.5),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: Colors.blue,),
            SizedBox(height: 10,),
            Center(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,))
          ],
        ),
      ),
    );
  }
}



class PayWallContainer extends StatelessWidget {

  final IconData icon;
  final String text;

  PayWallContainer({
    super.key,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Icon(icon, size: 26, color: Colors.blue,),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,)
      ],
    );
  }
}




class PulsAnimation extends StatefulWidget {

  final Widget child;
  final double scaleFactor;
  final Duration duration;

  const PulsAnimation({super.key, required this.child, required this.scaleFactor, required this.duration});

  @override
  State<PulsAnimation> createState() => _PulsAnimationState();
}

class _PulsAnimationState extends State<PulsAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1, end: widget.scaleFactor).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.repeat(reverse: true);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
    
  }



  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}


class AnimatedContentWidget extends StatefulWidget {
  final String title;
  final String content;
  //final Duration? startDelay;

  const AnimatedContentWidget({
    super.key,
    required this.title,
    required this.content,
    //required this.startDelay
  });

  @override
  State<AnimatedContentWidget> createState() => _AnimatedContentWidgetState();
}

class _AnimatedContentWidgetState extends State<AnimatedContentWidget> with SingleTickerProviderStateMixin {

  String _displayedTitle = '';
  String _displayedContent = '';
  bool _isTitleComplete = false;
  bool _isContentComplete = false;
  int _currentTitleIndex = 0;
  int _currentContentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startAnimation();
    
    
  }

  void _startAnimation() {
    // Title animasyonunu başlat
    _timer = Timer.periodic(const Duration(milliseconds: 3), (timer) {
      if (_currentTitleIndex < widget.title.length) {
        setState(() {
          _displayedTitle += widget.title[_currentTitleIndex];
          _currentTitleIndex++;
        });
      } else if (!_isTitleComplete) {
        setState(() {
          _isTitleComplete = true;
        });
      } else if (_currentContentIndex < widget.content.length) {
        // Content animasyonunu başlat
        setState(() {
          _displayedContent += widget.content[_currentContentIndex];
          _currentContentIndex++;
        });
      } else {
        setState(() {
          _isContentComplete = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //
          children: [
            const SizedBox(height: 10),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _displayedTitle,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                if (!_isTitleComplete)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    //child: _buildAIIcon(),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _displayedContent,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                if (_isTitleComplete && !_isContentComplete)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    //child: _buildAIIcon(),
                  ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  /* Widget _buildAIIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.blue.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.smart_toy, // veya Icons.psychology, Icons.smart_toy
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  } */


}

