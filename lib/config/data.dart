
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


class AiApiContent {
  
  static String aiPrompt ({required String languageCode}) {

    return """ [GEREKLİ DİL = $languageCode]
  Sen, gönderilen görseldeki **TARİHİ ESERİ VEYA YAPIYI** analiz eden, bu alanda uzman, dikkatli bir **MÜZE KATALOGLAYICISI ve REHBERİSİN**.
  Görevin, **KESİNLİKLE** görselin yalnızca **FİZİKSEL BETİMLEMESİNİ YAPMAK DEĞİL**, doğrudan görseldeki **TARİHİ/KÜLTÜREL ÖNEME** sahip eseri tanımlamak ve onunla ilgili bilgileri yapılandırmaktır.
  **İSTENEN YANIT:** Görseldeki eseri veya yapıyı tanımla ve bir rehberin anlatacağı gibi önemli bilgileri (tarih, mimari, önem, işlev vb.) anlat.


 **YAPILANDIRILMIŞ JSON FORMATI:**
 - Yanıt **BAŞKA HİÇBİR METİN İÇERMEMELİ**, yalnızca JSON kodu olmalıdır.
 - JSON anahtarları (key) İngilizce olmalıdır ("Titel", "Explanation").
 - JSON değerleri (value) yukarıda belirtilen GEREKLİ DİLDE ($languageCode) olmalıdır.
 - Ana nesne bir JSON dizisi olmalı ve içinde esere ait birden fazla bilgi bloğu olmalıdır.
 - **"Titel"** key'ine karşılık gelen değerin sonuna **KESİNLİKLE** "Identification" veya benzeri bir kelime **EKLEME**.
 - Title ve Explanation da sınır yok gerektiği kadar yapabilirsin

  

  **JSON Yapısı Örneği:**

  [

     {

         "Titel" : "eserin ya da yapının adı buraya yazılacak",

         "Explanation" : "eser ya da yapı ile ilgili açıklama buraya yazılacak"

     },

     {

         "Titel" : "diğer konu başlığı buraya yazılacak",

         "Explanation" : "konu başlığı ile ilgili yazı"

     }

  ]

  **Şimdi görseldeki tarihi eseri analiz et ve talimatlara tam uyarak, sadece tarihi ve kültürel bilgiye odaklanarak, JSON çıktısını üret.**

  """;
  }

}




class ApiOperations {
  
  /* Future<List<ContentModel>> sendImageAndGetJson (File imageFile) async {

    final model = GenerativeModel(model: "gemini-2.5-flash", apiKey: "");
    List<ContentModel> icerikListesi = [];

    final jsonSchema = Schema(
      SchemaType.array,
      //description: 'A comprehensive analysis of the historical artifact in the image, presented as an array of topic objects.',
      items: Schema(
        SchemaType.object,
        //description: 'A single topic entry about the artifact.',
        properties: {
          "Title" : Schema(
            SchemaType.string,
            //description: "title about the historical artifact or structure in the photograph"
          ),
          "Explanation" : Schema(
            SchemaType.string,
            //description: "article about the described photograph"
          )
        },
        requiredProperties: ["Title" , "Explanation"]
      )
    );

    final String languageCode = await getDeviceLanguageCode();

    final bytes = await imageFile.readAsBytes();
    final contenst = [
      Content.multi(
        [
          DataPart("image/jpeg", Uint8List.fromList(bytes)),
          TextPart(AiApiContent.aiPrompt(languageCode: languageCode))
        ]
      )
    ];

    final config = GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: jsonSchema,
    );

    final response = await model.generateContent(
      contenst,
      generationConfig: config
    );

    final jsonString = response.text ?? "[]";
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject is List) {
      icerikListesi = (jsonObject as List).map((e) => ContentModel.fromMap(e as Map<String, dynamic>)).toList();
    }

    return icerikListesi;

  } */



  Future<List<ContentModel>> sendImageAndGetJson (File imageFile) async {

    List<ContentModel> icerikListesi = [];

    final String languageCode = await getDeviceLanguageCode();
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('https://us-central1-history-identifier.cloudfunctions.net/analyzeImage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'imageBase64': base64Image,
        'languageCode': languageCode,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final jsonString = responseBody['data'];
      final jsonObject = jsonDecode(jsonString);
      if (jsonObject is List) {
        icerikListesi = (jsonObject as List).map((e) => ContentModel.fromMap(e as Map<String, dynamic>)).toList();
      }
    }

    return icerikListesi;

  }





  Future<String> getDeviceLanguageCode () async {

    final Locale deviceLocale = await PlatformDispatcher.instance.locales.first;

    return deviceLocale.languageCode;
  }


}



class SubscriptionManager {
  
  static Future<bool> isUserSubscribed() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      bool isPro = customerInfo.entitlements.all["pro"]?.isActive ?? false;
      //print("ABONELİK DURUMU AKTİFİ DEGİLMİ : $isPro");
      return isPro;
    } catch (e) {
      //print("Abonelik kontrolü hatası : $e");
      return false;
    }
  }


  static Future<bool> hasEverSubscribed () async {

    try {

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      List<String> allPurchases = customerInfo.allPurchasedProductIdentifiers;
      bool hasEverpurcheses = allPurchases.isNotEmpty;
      //print("ABONELIK LISTESI : ${allPurchases.length}");

      return hasEverpurcheses;

    } catch (e) {
      return false;
    }

  }


  static Future<List<Package>?> getAvailablePackage() async {

    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {

        return offerings.current!.availablePackages;

      }
      return null;
    } catch (e) {
      //print("Paket getirme hatası : $e");
      return null;
    }

  }


  static Future<bool> purchasePackage(Package package) async {


    try {
      final purchaseParams = PurchaseParams.package(package);
      PurchaseResult result = await Purchases.purchase(purchaseParams);
      
      bool isPro = result.customerInfo.entitlements.all['pro']?.isActive ?? false;
      if (isPro) {
        //print('Satın alma başarılı! ✅');
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        //print('Kullanıcı satın almayı iptal etti');
      } else {
        //print('Satın alma hatası: ${e.message}');
      }
      return false;
    }

  }


  static Future<bool> restorePurchases() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      bool isPro = customerInfo.entitlements.all['pro']?.isActive ?? false;
      
      if (isPro) {
        //print('Abonelik geri yüklendi! ✅');
        return true;
      } else {
        //print('Geri yüklenecek abonelik bulunamadı');
        return false;
      }
    } catch (e) {
      //print('Geri yükleme hatası: $e');
      return false;
    }
  }


}



class DailyLimitManager {

  static Future<void> getDateTime(WidgetRef ref) async {

    final toDay = DateTime.now().day;
    final savedDay = ref.read(savedDayProvider);

    //print("TODAY : $toDay");
    //print("KAYDEDİLEN GÜN : $savedDay");

    if (toDay > savedDay || savedDay > toDay) {
      ref.read(saveFreePhotoTakeProvider.notifier).state = 0;
      ref.read(savedDayProvider.notifier).state = toDay;

      //print("YENI KAYDEDILEN GUN : ${ref.read(savedDayProvider)}");
    }
    
    
    
  }

}




 

class Version {
  

  static Future<bool> versionCheck () async {

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    String currentVersion = "";
    String latestversion = "";
    bool version;

    final response = await Dio().get("https://rxfbdpuisrrnmvbnifdc.supabase.co/storage/v1/object/public/json_dosyasi/version.json?v=$timestamp");
    if (response.statusCode == 200) {
      
      latestversion = response.data["version"];

    }

    final info = await PackageInfo.fromPlatform();
    currentVersion = info.version;

    print("MEVCUT VERSİON : $currentVersion");
    print("YENI VERSİON : $latestversion");

    if (currentVersion != latestversion) {
      return false;
    }
    else {
      return true;
    }

  }


}








