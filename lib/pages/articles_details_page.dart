
import 'package:flutter/material.dart';

class ArticlesDetailPage extends StatelessWidget {

  final String? image;
  final String? title;
  final String content;

  ArticlesDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        
          children: [
        
            SafeArea(
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 36,)),
                ),
              ),
            ),

            
        
            (image!.isNotEmpty || image != null) 
            ? Padding(
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
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(image!, height: 450, width: double.maxFinite, fit: BoxFit.cover,)
                ),
              ),
            ) 
            : Icon(Icons.image_not_supported),
        
            SizedBox(height: 25,),

            (title != null || title!.isNotEmpty) 
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(title!, style: Theme.of(context).textTheme.headlineLarge,),
            ) 
            : Text(""),
        
            SizedBox(height: 25,),

            (content != null || content!.isNotEmpty) 
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(content, style: Theme.of(context).textTheme.bodyMedium,),
            ) 
            : Text(""),
        
            SizedBox(height: 60,),

          ],
        
        ),
      ),
    );
  }
}