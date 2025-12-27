

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaticContentPage extends StatelessWidget {
 
  final List<String> content;
  final String imagePath;

  const StaticContentPage({
    super.key,
    required this.content,
    required this.imagePath
  });

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
                }, icon: Icon(Icons.arrow_back, size: 36, color: Theme.of(context).iconTheme.color,))
              ),
            )
          ),


          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Image.asset(imagePath),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: content.length - 1,
                    itemBuilder: (context, index) {
                      var item = content[index + 1];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: item == content[1] ? Text(item, style: Theme.of(context).textTheme.headlineLarge,) : Text(item, style: Theme.of(context).textTheme.bodyMedium,) ,
                      );
                    }
                  )

                ],
              ),
            )
          )
          
        ],
      ),
    );
  }
}