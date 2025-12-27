
import 'package:flutter/material.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
  bool isHasEverSub = true;


  @override
  void initState() {

    super.initState();
    loadPackages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subcheck();
    });

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

    setState(() {
      isLoading = false;
      _packeges = packages;
    });

    if (packages == null || packages.isEmpty) {
      print('❌ Paket bulunamadı!');
      return;
    }

  }


  Future<void> handlePurchase() async {

    await subcheck();

    if (isSub == false) {

      if (_packeges == null || _packeges!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paketler Yüklenemedi")));
        return;
      }

      final selectedpackage = _packeges![selectedIndex];

      bool success = await SubscriptionManager.purchasePackage(selectedpackage);

      if (success) {
        Navigator.pop(context, true);
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
                                
                    Text("Unlock History's \nHidden secrets", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),),
                                
                    SizedBox(height: 20,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        ContainerPayyWall(icon: Icons.document_scanner, label: "Unlimited Scans"),
                        ContainerPayyWall(icon: Icons.article_outlined, label: "More \nDetail")
                      ],
                    ),
                                
                    SizedBox(height: 15,),
                        
                    
                    Visibility(
                      visible: !isHasEverSub,
                      child: buildPackageCard(
                        index: 0, 
                        title: "Monthly Plan",  
                        subtitle: "", 
                        price: (_packeges != null && _packeges!.isNotEmpty) && (_packeges![0].storeProduct.introductoryPrice != null) ? "${_packeges![0].storeProduct.introductoryPrice!.priceString}" : "error",
                        period: (_packeges != null && _packeges!.isNotEmpty) && !isHasEverSub ? "${_packeges![0].storeProduct.priceString}" : "${_packeges![0].storeProduct.priceString}",
                        isDiscount: true
                      ),
                    ),

                    SizedBox(height: 15,),
                                
                    buildPackageCard(
                      index: 2, 
                      title: "Monthly Plan", 
                      subtitle: "", 
                      price: (_packeges != null && _packeges!.isNotEmpty) ? "${_packeges![2].storeProduct.priceString}" : "aa", 
                      period: "/ Mounthly", 
                      isDiscount: false
                    ),
                                
                    SizedBox(height: 15,),
                                
                    buildPackageCard(
                      index: 1, 
                      title: "Weekly", 
                      subtitle: "", 
                      price: (_packeges != null && _packeges!.isNotEmpty) ? "${_packeges![1].storeProduct.priceString}" : "bb", 
                      period: "/ weekly",
                      isDiscount: false
                    ),

                    SizedBox(height: 10,),

                    Text("ABONELIK DURUMU : $isSub", style: TextStyle(color: Colors.white, fontSize: 22),),
                    Text("HERHANGİ BİR ABONELİK OLMUŞMU : $isHasEverSub", style: TextStyle(color: Colors.white, fontSize: 18),),
                        
                    
                    //Spacer(),
                                
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
                        }, child: Text("Continue", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),)),
                      ),
                    )),
                
                    SizedBox(height: 10,),
                                
                                
                  ],
                ) : SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator())),
            
            
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
                  child: Text("%30 İNDİRİM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
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
                              Text(period, style: TextStyle(color: Colors.white, fontSize: 14, decoration: isDiscount ? TextDecoration.lineThrough : TextDecoration.none, decorationColor: Colors.white),)
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
          content: Text("You have already subscribed", style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("Ok", style: TextStyle(color: Colors.white),))
          ],
        );
      }
    );

  }


}