
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/main.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PayWallPage extends StatefulWidget {
  const PayWallPage({super.key});

  @override
  State<PayWallPage> createState() => _PayWallPageState();
}

class _PayWallPageState extends State<PayWallPage> with SingleTickerProviderStateMixin {

  List<Package>? _packeges = [];
  int selectedIndex = 0;
  bool isLoading = true;
  bool isSub = false;
  bool isHasEverSub = false;


  @override
  void initState() {

    super.initState();
    loadPackages();

    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subcheck();
    });

    /* if (isHasEverSub) {
        selectedIndex = 2;
      }
      else {
        selectedIndex = 0;
    } */

  }


  Future<void> subcheck () async {

    final subscriptionStatus = await SubscriptionManager.isUserSubscribed();
    final hasEverSub = await SubscriptionManager.hasEverSubscribed();
    
    setState(() {
      isSub = subscriptionStatus;
      isHasEverSub = hasEverSub;
    });

  }


  Future<void> loadPackages() async {

    setState(() {
      isLoading = true;
      
    });

    final packages = await SubscriptionManager.getAvailablePackage();

    print("İOS PAKETLERİ : $packages");

    setState(() {
      isLoading = false;
      _packeges = packages;
    });

    if (packages == null || packages.isEmpty) {
      //print('❌ Paket bulunamadı!');
      return;
    }

  }


  Future<void> handlePurchase() async {
    print("BİR");
    await subcheck();
    print("İKİ");
    if (isSub == false) {
      print("ÜÇ");
      if (_packeges == null || _packeges!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paketler Yüklenemedi")));
        print("DÖRT");
        return;
      }
      print("BEŞ");
      final selectedpackage = _packeges![selectedIndex];

      bool success = await SubscriptionManager.purchasePackage(selectedpackage);
      print("ALTI");
      if (success) {
        //Navigator.pop(context, true);
        Navigator.of(context).pop(true);
      }

    }
    else {
      alertDialog(context);
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 27, 33, 1),

      body: Stack(
        
        children: [
      
          SingleChildScrollView(
            child: Column(
              
              children: [
            
                Stack(
                  children: [
                    Image.asset("assets/images/history/ayasofya.png", width: double.maxFinite, height: MediaQuery.of(context).size.height * 0.3, fit: BoxFit.cover,),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.bottomCenter,
                          end: AlignmentGeometry.topCenter,
                          stops: [
                            0,
                            0.4,
                          ],
                          colors: [
                            Color.fromRGBO(15, 27, 33, 1),
                            Colors.transparent
                          ]
                        )
                      ),
                    )
                  ],
                ),
            
            
            
                !isLoading ? Column(
                  
                  children: [
                                
                    Text("navigation.paywall_title".tr(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),),
                                
                    SizedBox(height: 20,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        ContainerPayyWall(icon: Icons.document_scanner, label: "navigation.payWallContainer_1".tr()),
                        ContainerPayyWall(icon: Icons.article_outlined, label: "navigation.payWallContainer_2".tr()),
                        ContainerPayyWall(icon: Icons.payment, label: "navigation.payWallContainer_3".tr())
                      ],
                    ),

                    /* Column(
                      spacing: 20,
                      children: [
                        PayWallContainer(icon: Icons.document_scanner, text: "navigation.payWallContainer_1".tr()),
                        PayWallContainer(icon: Icons.article_outlined, text: "navigation.payWallContainer_2".tr()),
                        PayWallContainer(icon: Icons.payment, text: "navigation.payWallContainer_3".tr())
                      ],
                    ), */
                                
                    SizedBox(height: 15,),
                        
                    
                    Platform.isAndroid ? Visibility(
                      visible: !isHasEverSub,
                      child: buildPackageCard(
                        index: 0, 
                        title: "navigation.monthly_30".tr(),  
                        subtitle: "", 
                        price: (_packeges != null && _packeges!.isNotEmpty) && (_packeges![0].storeProduct.introductoryPrice != null) ? "${_packeges![0].storeProduct.introductoryPrice!.priceString}" : "error",
                        period: (_packeges != null && _packeges!.isNotEmpty) && !isHasEverSub ? "${_packeges![0].storeProduct.priceString}" : "NULL",
                        isDiscount: true
                      ),
                    ) :
                    Visibility(
                      visible: !isHasEverSub,
                      child: buildPackageCard(
                        index: 0, 
                        title: "navigation.monthly_30".tr(),  
                        subtitle: "", 
                        price: (_packeges != null && _packeges!.isNotEmpty) && (_packeges![0].storeProduct.discounts != null) ? "${_packeges![0].storeProduct.discounts![0].priceString}" : "error",
                        period: (_packeges != null && _packeges!.isNotEmpty) && !isHasEverSub ? "${_packeges![0].storeProduct.priceString}" : "${_packeges![0].storeProduct.priceString}",
                        isDiscount: true
                      ),
                    ),

                    
                    Visibility(
                      visible: isHasEverSub,
                      child: buildPackageCard(
                        index: 2, 
                        title: "navigation.monthly_30".tr(), 
                        subtitle: "", 
                        price: (_packeges != null && _packeges!.isNotEmpty) ? "${_packeges![2].storeProduct.priceString}" : "*", 
                        period: "", 
                        isDiscount: false
                      ),
                    ),
                                
                    SizedBox(height: 15,),
                                
                    buildPackageCard(
                      index: 1, 
                      title: "navigation.weekly".tr(), 
                      subtitle: "", 
                      price: (_packeges != null && _packeges!.isNotEmpty) ? "${_packeges![1].storeProduct.priceString}" : "*", 
                      period: "",
                      isDiscount: false
                    ),


                    SizedBox(height: 10,),

                    Text("ABONELIK DURUMU : $isSub", style: TextStyle(color: Colors.white, fontSize: 22),),
                    Text("HERHANGİ BİR ABONELİK OLMUŞMU : $isHasEverSub", style: TextStyle(color: Colors.white, fontSize: 18),), 
                    
                                
                    SafeArea(child: PulsAnimation(
                      scaleFactor: 1.2,
                      duration: Duration(seconds: 1),
                      child: SizedBox(
                        height: 60,
                        width: 230,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          onPressed: () {
                          handlePurchase();
                        }, child: Text("navigation.continue".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),)),
                      ),
                    )),
                
                    SizedBox(height: 10,),
                                
                                
                  ],
                ) : SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator())),


  
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () async {

                        final url = Uri.parse("https://sites.google.com/view/endlesfootball/ana-sayfa");
                        await launchUrl(url, mode: LaunchMode.externalApplication);

                      }, child: Text("Privacy Policy", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white, fontSize: 16),)),
                      TextButton(onPressed: () async {

                        final url = Uri.parse("https://www.apple.com/legal/internet-services/itunes/dev/stdeula/");
                        await launchUrl(url, mode: LaunchMode.externalApplication);

                      }, child: Text("User License Agreement", style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white, fontSize: 16),)),
                    ],
                  ),
                )
            
            
              ],
            ),
          ),
      
      
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Align(
                alignment: AlignmentGeometry.topLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MyApp()));
                }, icon: Icon(Icons.arrow_back_ios, size: 36, color: Colors.white,))
              ),
            ),
          ),


          

        ],
      )
    );
  }

  
  Widget buildPackageCard ({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required bool isDiscount
  }) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,),
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        child: Container(
          //width: 400,
          //height: 100,
          decoration: BoxDecoration(
            color: isDiscount ? Colors.blue : Color.fromRGBO(16, 40, 52, 1),
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withAlpha(100), width: 2),
            borderRadius: BorderRadius.circular(14)
          ),
          child: Column(
            children: [

              Visibility(
                visible: isDiscount,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("navigation.discount_text".tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                )
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color.fromRGBO(16, 40, 52, 1),
                    //border: Border.all(color: Colors.blue)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,),
                    child: Center(
                      child: SizedBox(
                        child: ListTile(  
                        
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(price, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                              Visibility(visible: isDiscount, child: Text(period, style: TextStyle(color: Colors.white, fontSize: 14, decoration: isDiscount ? TextDecoration.lineThrough : TextDecoration.none, decorationColor: Colors.white),))
                            ],
                          ),
                          leading: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                              activeColor: Colors.blue,
                              //fillColor: WidgetStateProperty.all(Colors.grey.withAlpha(100)),
                              overlayColor: WidgetStateProperty.all(Colors.amber),
                              side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.withAlpha(100)),
                              value: isSelected, 
                              onChanged: (_) {}
                            ),
                          ),
                          title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),),
                          //subtitle: Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future alertDialog (BuildContext context) {

    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(15, 27, 33, 1),
          content: Text("navigation.already_subscribed".tr(), style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("navigation.ok".tr(), style: TextStyle(color: Colors.white),))
          ],
        );
      }
    );

  }


}