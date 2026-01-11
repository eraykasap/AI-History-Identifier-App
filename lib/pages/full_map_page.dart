

import 'package:flutter/material.dart';
import 'package:history_identifier/widgets/widgets.dart';

class FullMapViewPage extends StatelessWidget {
  const FullMapViewPage({super.key});

  @override
  Widget build(BuildContext context) {
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


          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.75,
            child: MapViewWidget()
          )

        ],
      ),
    );
  }
}

