
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/model/model.dart';

import 'package:history_identifier/pages/home_page.dart';
import 'package:history_identifier/pages/photo_page.dart';
import 'package:history_identifier/pages/profile_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:purchases_flutter/purchases_flutter.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
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
  //await Hive.deleteBoxFromDisk("themeModeSave");

  runApp(EasyLocalization(
    path: "assets/translations",
    supportedLocales: [Locale("en"), Locale("tr")],
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

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    loadHiveBox();
    initializeRevenueCat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DailyLimitManager.getDateTime(ref);
    });
    
  }


  Future<void> initializeRevenueCat() async {
    final apiKey = "goog_vMhnSxifPOsRTWyMLofGZZKPRuv";
    await Purchases.configure(PurchasesConfiguration(apiKey));

    ref.read(isCustomerSubProvider.notifier).state = await SubscriptionManager.isUserSubscribed();

    print("ABONELİK DURUMU : ${ref.read(isCustomerSubProvider)}");
  }


  Future<void> loadHiveBox () async {

    await ref.read(contentSaveProvider.notifier).loadFromBox();
    ref.read(photoCounterProvider.notifier).state = box.get("photoCounter") ?? 0;

    String themeModeString = themeModeBox.get("themeModeSave") ?? "ThemeMode.light";
    ThemeMode themeMode = themeModeString.contains("dark") ? ThemeMode.dark : ThemeMode.light;
    ref.read(themeModeProvider.notifier).state = themeMode;

    ref.read(saveFreePhotoTakeProvider.notifier).state = freePhotoTake.get("freePhotoTake") ?? 0;

    ref.read(savedDayProvider.notifier).state = savedDay.get("savedDay") ?? 0;
    print("YENİ SAVED DAY : ${ref.read(savedDayProvider)}");
    
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

    }
  }


  @override
  Widget build(BuildContext context) {

    final currentMode = ref.watch(themeModeProvider);

    return MaterialApp(

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,

      debugShowCheckedModeBanner: false,

      themeMode: currentMode,
      theme: lightTheme,
      darkTheme: darkTheme,

      home: BottomNavBarCustom(),
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
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: allPages[selectedIndex],

      bottomNavigationBar: bottomNavgationBar(
        selectedIndex, 
        context,
        ref,
        (index) {
          setState(() {
            selectedIndex = index;
          });
        }
        
        
      ),

    );
  }
}



Widget bottomNavgationBar(int selectindex, BuildContext context, WidgetRef ref, Function(int) onSelect) {
  
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

        SizedBox(
          height: 85,
          child: ElevatedButton(
            onPressed: () {

              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PhotoScannerPage()));
              
            }, 
            child: Row(children: [
              Icon(Icons.photo_camera_outlined, size: 34, color: Theme.of(context).colorScheme.secondary,),
              SizedBox(width: 8,),
              Text("navigation.scan".tr(), style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
            ],),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.primary,
              overlayColor: Colors.grey.shade800
            ),
          ),
        )



      ],
    ),
  );
}












