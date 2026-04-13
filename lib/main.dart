
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/model/model.dart';

import 'package:history_identifier/pages/home_page.dart';
import 'package:history_identifier/pages/onboard_page.dart';
import 'package:history_identifier/pages/paywall_page.dart';
import 'package:history_identifier/pages/photo_page.dart';
import 'package:history_identifier/pages/profile_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/theme.dart';
import 'package:history_identifier/widgets/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:upgrader/upgrader.dart';



void main() async {

  

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Upgrader.clearSavedSettings();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ContentSaveModelAdapter());
  Hive.registerAdapter(ContentModelAdapter());

  await Hive.openBox<ContentSaveModel>('savedContent');
  await Hive.openBox<int>("photoCounter");
  await Hive.openBox<String>("themeModeSave");
  await Hive.openBox<int>("freePhotoTake");
  await Hive.openBox<int>("savedDay");
  await Hive.openBox<bool>("saveOnboard");
  //await Hive.deleteBoxFromDisk("themeModeSave");

  runApp(EasyLocalization(
    path: "assets/translations",
    supportedLocales: [Locale("en"), Locale("tr"), Locale("ar"), Locale("chi"), Locale("de"), Locale("es"), Locale("fr"), Locale("hi"), Locale("it"), Locale("ja"), Locale("ko"), Locale("pl"), Locale("pt"), Locale("ru")],
    fallbackLocale: Locale("en"),
    child: ProviderScope(child: MyApp())
  )
  );
  
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {

  var box = Hive.box<int>("photoCounter");
  var themeModeBox = Hive.box<String>("themeModeSave");
  var freePhotoTake = Hive.box<int>("freePhotoTake");
  var savedDay = Hive.box<int>("savedDay");
  var saveOnboard = Hive.box<bool>("saveOnboard");

  List<dynamic> nearLocationHistory = []; 

  List<NearLatLng> nearLatLngList = [];
  

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    

    loadHiveBox();
    initializeRevenueCat();
    
    getEventWikiPedia();
    getWikiArticals();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DailyLimitManager.getDateTime(ref);
    });
    
  }


  /* Future<void> fetchhistoricalPlace () async {

    try {
      Position position = await ApiOperations.getUserLatLang();
      print("!!!!!!!!! KONUM ALINDI !!!!!!!!!!: ${position.latitude}, ${position.longitude}");
      nearLocationHistory = await getNearbyHistoricalPlaces(position.latitude, position.longitude);
      print("!!!!!!!!!! ${nearLocationHistory.length} !!!!!!!!!!"); 
      ref.read(nearHistoryPlace.notifier).state = nearLocationHistory;
      

      List<NearHistoricalPlace> places = nearLocationHistory.map((e) => NearHistoricalPlace.fromJson(e)).toList();



      for (var element in places) {
        //nearLatLngList.add(NearLatLng(lat: element.lat, lng: element.lon));
        ref.read(nearLatLngPlace.notifier).state.add(NearLatLng(lat: element.lat, lng: element.lon, name: element.name));
        //print("!!!!!!!!!!!!!!!!!!!!!!!!! ${ref.read(nearLatLngPlace).length} !!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      }



    } catch (e) {
      print("!!!!! HATA !!!!! : $e");
    }

  }  */

  /* Future<List<dynamic>> getNearbyHistoricalPlaces (double lat, double lng) async {

    const int radius = 50000;

    final query = '''
    [out:json][timeout:25];
    (
      node["tourism"~"museum"](around:$radius, $lat, $lng);
      
      node["historic"](around:$radius, $lat, $lng);
      
      
    );
    out center; ''';

    final url = Uri.parse("https://overpass-api.de/api/interpreter");
    //final url = Uri.parse("https://overpass.kumi.systems/api/interpreter");

    try {

      final response = await http.post(
        url,
        body: {'data': query},
        headers: {
          'User-Agent': 'History Identifier/1.0', // 
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['elements'] ?? [];
      }
      else {
        print("!!!!! API Hatası !!!!! : ${response.statusCode}");
        return [];
      }
      
    } catch (e) {

      print("!!!!! Bağlantı Hatası !!!!! : $e");
      return [];

    }


    

  } */

  
  Future<void> getEventWikiPedia () async {

    final now = DateTime.now();
    final language = await ApiOperations().getDeviceLanguageCode();
    final event = await WikipediaHistoryService.getEventForDate(month: now.month, day: now.day, lang: language);
    final limited = event.take(20).toList();
    ref.read(historicalEventsProvider.notifier).state = limited;

    //print('Toplam ${event.length} olay bulundu');
    for (final event in event) {
      //print('Yıl: ${event.year} /n');
      //print('Başlık: ${event.title} /n');
      //print('Başlık: ${event.text} /n');
      //print('Fotoğraf: ${event.imageUrl} /n');
      //print('---');
    }

  }


  Future<void> getWikiArticals () async {

    final articles = await WikiArticleService.fetchHistoryArticles();
    ref.read(wikiArticlesProvider.notifier).state = articles;

    print("!!!!!!!!!!!!!!!!!!!!!!!!!! toplam makale : ${articles.length} !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

  }



  Future<void> initializeRevenueCat() async {
    final apiKey = Platform.isAndroid ? "goog_vMhnSxifPOsRTWyMLofGZZKPRuv" : "appl_aEwBKMUYjJIaEUdhbYwXuvPFWqf";
    await Purchases.configure(PurchasesConfiguration(apiKey));

    ref.read(isCustomerSubProvider.notifier).state = await SubscriptionManager.isUserSubscribed();

    //print("ABONELİK DURUMU : ${ref.read(isCustomerSubProvider)}");
  }


  Future<void> loadHiveBox () async { 

    await ref.read(contentSaveProvider.notifier).loadFromBox();
    ref.read(photoCounterProvider.notifier).state = box.get("photoCounter") ?? 0;

    String themeModeString = themeModeBox.get("themeModeSave") ?? "ThemeMode.light";
    ThemeMode themeMode = themeModeString.contains("dark") ? ThemeMode.dark : ThemeMode.light;
    ref.read(themeModeProvider.notifier).state = themeMode;

    ref.read(saveFreePhotoTakeProvider.notifier).state = freePhotoTake.get("freePhotoTake") ?? 0;

    savedDay.isNotEmpty ? ref.read(savedDayProvider.notifier).state = savedDay.get("savedDay") ?? 0 : DateTime.now().day;
    //print("YENİ SAVED DAY : ${ref.read(savedDayProvider)}");

    
    saveOnboard.isNotEmpty ? ref.read(onBoardPageProvider.notifier).state = saveOnboard.get("saveOnboard") ?? false : ref.read(onBoardPageProvider);
    //print("KAYDEDİLEN PROVİDER ONBOARD DEĞERİ ${ref.read(onBoardPageProvider)}");

    //await DailyLimitManager.getDateTime(ref); //
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      int value = ref.read(photoCounterProvider);
      box.put("photoCounter", value);

      ThemeMode themeModeSave = ref.read(themeModeProvider);
      themeModeBox.put("themeModeSave", themeModeSave.toString());

      var freeTakePhotoValue = ref.read(saveFreePhotoTakeProvider);
      freePhotoTake.put("freePhotoTake", freeTakePhotoValue);

      var savedday = ref.read(savedDayProvider);
      savedDay.put("savedDay", savedday);

      var saveonBoardPage = ref.read(onBoardPageProvider);
      //print("KAYDEDİLEN ONBOARD DEĞERİ $saveonBoardPage");
      saveOnboard.put("saveOnboard", saveonBoardPage);

    }
  }


  @override
  Widget build(BuildContext context) {

    final currentMode = ref.watch(themeModeProvider);
    final onBoardView = ref.watch(onBoardPageProvider);
    //print("MYAPP ONBOARD BOOL DEGERİ ${ref.read(onBoardPageProvider)}");

    return MaterialApp(
    
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
    
      debugShowCheckedModeBanner: false,
    
      themeMode: currentMode,
      theme: lightTheme,
      darkTheme: darkTheme,
    
      home: UpgradeAlert(
        upgrader: Upgrader(
          messages: LocalizedUpgraderMessages()
        ),
        dialogStyle: UpgradeDialogStyle.cupertino,
        barrierDismissible: false,
        showIgnore: false,
        showLater: false,
        onIgnore: () => false,
        onLater: () => false,
        onUpdate: () {
          SystemNavigator.pop();
          return true;
        } ,
        cupertinoButtonTextStyle: TextStyle(color: Colors.black),
        child: onBoardView ? BottomNavBarCustom() : OnboardPage(),
      ) 
    
    );
  }
}



class BottomNavBarCustom extends ConsumerStatefulWidget {
  const BottomNavBarCustom({super.key});

  @override
  ConsumerState<BottomNavBarCustom> createState() => _BottomNavBarCustomState();
}

class _BottomNavBarCustomState extends ConsumerState<BottomNavBarCustom> {


  int selectedIndex = 0;
  bool version = true;
  

  late PhotoScannerPage photoScannerPage;
  late HomePage homePage;
  late ProfilePage profilePage;
  late List<Widget> allPages;

  @override
  void initState() {
    super.initState();

    photoScannerPage = PhotoScannerPage();
    homePage = HomePage();
    profilePage = ProfilePage();
    allPages = [homePage, profilePage];

    //versionControl();

  }

  Future<void> versionControl() async {
    version = await Version.versionCheck();
    print("VERSİON NUMARASI : $version");
    setState(() {
      
    });
  }

  

  @override
  Widget build(BuildContext context) {
    
    return !version ? Scaffold(
      
      body: Center(
        child: shoeMessage()
      ),
    ) : Scaffold(
      extendBody: true,
      backgroundColor: /*Colors.blue,*/ Theme.of(context).scaffoldBackgroundColor, 
      body: allPages[selectedIndex],
      
    
      bottomNavigationBar: bottomNavigationBar(
        selectedIndex, 
        context, 
        ref, 
        (index) => setState(() {
          selectedIndex = index;
        }), 
        () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PhotoScannerPage()))
      ),  
    
      
    
    );
  }


  Widget shoeMessage () {
     return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        title: Text("navigation.app_version_text".tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          TextButton(onPressed: () {
            if (Platform.isAndroid) {
              
            }
            else {

            }
          }, child: Text("navigation.app_version_text_button".tr()))
        ],
      );
  }


}

class LocalizedUpgraderMessages extends UpgraderMessages {
  
  String get title => 'upgrader.title'.tr();

  
  //String get messages => 'upgrader.message'.tr();
  String get messages => " ";

  
  //String get prompt => 'upgrader.prompt'.tr();
  String get prompt => " ";

  
  String get buttonTitleUpdate => 'upgrader.button_update'.tr();
  

  

}


Widget bottomNavigationBar(int selectIndex, BuildContext context, WidgetRef ref, Function(int) onSelect, VoidCallback onScanTap) {
  return Container(
    
    decoration: BoxDecoration(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 15,
          offset: Offset(0, 0)
        )
      ]
    ),
    child: SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Arka plan bar 
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Container(
              height: 100,
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Home butonu
                  NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: "navigation.home".tr(),
                    isSelected: selectIndex == 0,
                    onTap: () => onSelect(0),
                    context: context,
                  ),
    
                  // FAB için boşluk
                  const SizedBox(width: 72),
    
                  // Profil butonu
                  NavItem(
                    icon: Icons.bookmark_outline,
                    activeIcon: Icons.bookmark_rounded,
                    label: "navigation.profil".tr(),
                    isSelected: selectIndex == 1,
                    onTap: () => onSelect(1),
                    context: context,
                  ),
                ],
              ),
            ),
          ),
    
          // Ortadaki FAB (scan butonu)
          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: onScanTap,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(195, 150, 57, 1),
                  
                ),
                child: const Icon(
                  Icons.camera_alt_rounded, // ya da Icons.document_scanner
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



/* Widget bottomNavgationBar(int selectindex, BuildContext context, WidgetRef ref, Function(int) onSelect) {
  
  return SafeArea(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 85,
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          ),
          child: GNav(
            
            selectedIndex: selectindex,
            tabBackgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            color: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.color,
            activeColor: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!.color,
            
            iconSize: 34,
            tabBorderRadius: 24,
            gap: 5,
            tabMargin: const EdgeInsetsGeometry.symmetric(
              //vertical: 6,
              //horizontal: 6,
            ),
            tabs: [
              GButton(icon: Icons.home_outlined, text: "navigation.home".tr()), 
              GButton(icon: Icons.person_outline, text: "navigation.profil".tr()),
            ],
            
            onTabChange: (value) {
              onSelect(value);
            },
          ),
        ),

        SizedBox(
          width: 10,
        ),

      ],
    ),
  );
} */












