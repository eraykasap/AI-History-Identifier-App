
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/main.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/providers/providers.dart';

class OnboardPage extends ConsumerStatefulWidget {
  const OnboardPage({super.key});

  @override
  ConsumerState<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends ConsumerState<OnboardPage> {

  PageController pageController = PageController();

  int currentIdex = 0;

  final List<OnboardingStep> steps = [

    OnboardingStep(
      title: "navigation.onboardText_5".tr(), 
      description: "1. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_6.png"
    ),

    OnboardingStep(
      title: "navigation.onboardText_6".tr(), 
      description: "1. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_7.png"
    ),

    OnboardingStep(
      title: "navigation.onboardText_1".tr(), 
      description: "1. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_1.png"
    ),

    OnboardingStep(
      title: "navigation.onboardText_2".tr(), 
      description: "2. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_2.png"
    ),

    OnboardingStep(
      title: "navigation.onboardText_3".tr(), 
      description: "2. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_3.png"
    ),

    OnboardingStep(
      title: "navigation.onboardText_4".tr(), 
      description: "2. step description", 
      imageAssets: "assets/images/onboardphoto/onboard_5.png"
    )

  ];
 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(500),
      body: SafeArea(
        child: Column(
          children: [

            Align(
              alignment: AlignmentGeometry.topRight,
              child: IconButton(onPressed: () {
                ref.read(onBoardPageProvider.notifier).state = true;
                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => BottomNavBarCustom()));
              }, icon: Icon(Icons.cancel_outlined, color: Colors.black.withAlpha(50), size: 40,)),
            ),


            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    currentIdex = index;
                  });
                },
                controller: pageController,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return _buildPage(steps[index]);
                }
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentIdex < steps.length -1) {
                      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                    else {
                      ref.read(onBoardPageProvider.notifier).state = true;
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => BottomNavBarCustom()));
                    }
                  }, 
                  child: Text(currentIdex < steps.length -1 ? "Next" : "Get Started", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(195, 150, 57, 1)),
                ),
              ),
            ),



            
          ],
        ),
      ),
    );
  }


  Widget _buildPage (OnboardingStep step) {

    return Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(step.title, style: TextStyle(color: Colors.black, fontSize: 24),),
        ),

        SizedBox(height: 55,),

        Image.asset(step.imageAssets, scale: 2,),

        //Text(step.description, style: TextStyle(color: Colors.black),)

      ],
    );

  }


}