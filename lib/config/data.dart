
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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




class WikipediaHistoryService {
  static Future<List<HistoricalEvent>> getEventForDate({
    required int month,
    required int day,
    String lang = 'en',
  }) async {
    // Cihaz dilinde dene
    List<HistoricalEvent> events = await _fetchEvents(
      month: month,
      day: day,
      lang: lang,
    );

    // Cihaz dilinde 5'ten az geldiyse hiç gösterme, boş döndür
    if (events.length < 5 && lang != 'en') {
      debugPrint('⚠️ Cihaz dilinde yetersiz içerik, atlanıyor');
      return [];
    }

    return events;
  }

  static Future<List<HistoricalEvent>> _fetchEvents({
    required int month,
    required int day,
    required String lang,
  }) async {
    try {
      final url = Uri.parse(
        'https://$lang.wikipedia.org/api/rest_v1/feed/onthisday/events/$month/$day',
      );

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final allEvents = data['events'] as List?;
      if (allEvents == null || allEvents.isEmpty) return [];

      // 2000 öncesi filtresi
      final oldEvents = allEvents.where((e) {
        final year = e['year'] as int?;
        return year != null && year < 2000;
      }).toList();

      final pool = oldEvents.isNotEmpty ? oldEvents : allEvents;

      // Fotoğrafı olan eventleri filtrele
      final withImage = pool.where((e) {
        final pages = e['pages'] as List?;
        if (pages == null || pages.isEmpty) return false;
        return pages.any((p) => p['thumbnail'] != null);
      }).toList();

      debugPrint('📸 Fotoğraflı event: ${withImage.length}/${pool.length}');

      return withImage
          .map((e) => HistoricalEvent.fromJson(e))
          .toList();

    } catch (e) {
      debugPrint('Wikipedia fetch error: $e');
      return [];
    }
  }
}


class WikiArticleService {

  static const Map<String, List<String>> _categoriesByLang = {
    'tr': [
      'Antik_tarih',
      'Ortaçağ_tarihi',
      'Askeri_tarih',
      'Arkeoloji',
      'Antik_Mısır',
      'Roma_İmparatorluğu',
      'Osmanlı_İmparatorluğu',
      'Bizans_İmparatorluğu',
      'Tarih',
      'Antik_Yunan',
    ],
    'en': [
      'Ancient_history',
      'Medieval_history',
      'Military_history',
      'Archaeological_discoveries',
      'Ancient_civilizations',
      'Ancient_Egypt',
      'Roman_Empire',
      'Ottoman_Empire',
      'Byzantine_Empire',
      'History_by_period',
    ],
    'de': [
      'Alte_Geschichte',
      'Mittelalter',
      'Militärgeschichte',
      'Archäologie',
      'Altes_Ägypten',
      'Römisches_Reich',
      'Osmanisches_Reich',
      'Byzantinisches_Reich',
      'Geschichte',
      'Antike',
    ],
    'fr': [
      'Histoire_ancienne',
      'Histoire_médiévale',
      'Histoire_militaire',
      'Archéologie',
      'Égypte_antique',
      'Empire_romain',
      'Empire_ottoman',
      'Empire_byzantin',
      'Histoire',
      'Antiquité',
    ],
    'es': [
      'Historia_antigua',
      'Historia_medieval',
      'Historia_militar',
      'Arqueología',
      'Antiguo_Egipto',
      'Imperio_romano',
      'Imperio_otomano',
      'Imperio_bizantino',
      'Historia',
      'Civilizaciones_antiguas',
    ],
    'it': [
      'Storia_antica',
      'Medioevo',
      'Storia_militare',
      'Archeologia',
      'Antico_Egitto',
      'Impero_romano',
      'Impero_ottomano',
      'Impero_bizantino',
      'Storia',
      'Civiltà_antiche',
    ],
    'ru': [
      'Древняя_история',
      'Средневековье',
      'Военная_история',
      'Археология',
      'Древний_Египет',
      'Римская_империя',
      'Османская_империя',
      'Византийская_империя',
      'История',
      'Древние_цивилизации',
    ],
    'ja': [
      '古代史',
      '中世史',
      '軍事史',
      '考古学',
      '古代エジプト',
      'ローマ帝国',
      'オスマン帝国',
      'ビザンツ帝国',
      '歴史',
      '古代文明',
    ],
    'ko': [
      '고대사',
      '중세사',
      '군사사',
      '고고학',
      '고대_이집트',
      '로마_제국',
      '오스만_제국',
      '비잔틴_제국',
      '역사',
      '고대_문명',
    ],
    'pt': [
      'História_antiga',
      'História_medieval',
      'História_militar',
      'Arqueologia',
      'Antigo_Egito',
      'Império_Romano',
      'Império_Otomano',
      'Império_Bizantino',
      'História',
      'Civilizações_antigas',
    ],
    'ar': [
      'تاريخ_قديم',
      'تاريخ_العصور_الوسطى',
      'تاريخ_عسكري',
      'علم_الآثار',
      'مصر_القديمة',
      'الإمبراطورية_الرومانية',
      'الدولة_العثمانية',
      'الإمبراطورية_البيزنطية',
      'تاريخ',
      'حضارات_قديمة',
    ],
    'hi': [
      'प्राचीन_इतिहास',
      'मध्यकालीन_इतिहास',
      'सैन्य_इतिहास',
      'पुरातत्व',
      'प्राचीन_मिस्र',
      'रोमन_साम्राज्य',
      'उस्मानी_साम्राज्य',
      'बीजान्टिन_साम्राज्य',
      'इतिहास',
      'प्राचीन_सभ्यताएँ',
    ],
    'zh': [
      '古代史',
      '中世纪历史',
      '军事历史',
      '考古学',
      '古埃及',
      '罗马帝国',
      '奥斯曼帝国',
      '拜占庭帝国',
      '历史',
      '古代文明',
    ],
  };

  static const Map<String, String> _supportedLanguages = {
    'tr': 'tr',
    'en': 'en',
    'de': 'de',
    'fr': 'fr',
    'es': 'es',
    'it': 'it',
    'ja': 'ja',
    'ko': 'ko',
    'pt': 'pt',
    'ru': 'ru',
    'ar': 'ar',
    'hi': 'hi',
    'zh': 'zh',
  };

  static String _getLanguageCode() {
    final locale = ui.PlatformDispatcher.instance.locale;
    return _supportedLanguages[locale.languageCode] ?? 'en';
  }

  static List<String> _getCategoriesForLang(String lang) {
    return _categoriesByLang[lang] ?? _categoriesByLang['en']!;
  }

  static Future<List<int>> _fetchPageIdsFromCategory(
    String category,
    String lang,
  ) async {
    try {
      final uri = Uri.parse(
        'https://$lang.wikipedia.org/w/api.php'
        '?action=query'
        '&list=categorymembers'
        '&cmtitle=Category:$category'
        '&cmtype=page'
        '&cmlimit=50'
        '&format=json'
        '&origin=*',
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final members = data['query']?['categorymembers'] as List?;
      if (members == null) return [];

      return members.map<int>((m) => m['pageid'] as int).toList();
    } catch (e) {
      debugPrint('Category fetch error: $e');
      return [];
    }
  }

  static Future<WikiArticle?> _fetchArticle(
    int pageId,
    String lang,
  ) async {
    try {
      final uri = Uri.parse(
        'https://$lang.wikipedia.org/w/api.php'
        '?action=query'
        '&pageids=$pageId'
        '&prop=extracts|pageimages'
        '&exintro=true'
        '&explaintext=true'
        '&piprop=thumbnail'
        '&pithumbsize=500'
        '&format=json'
        '&origin=*',
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final pages = data['query']?['pages'] as Map<String, dynamic>?;
      if (pages == null) return null;

      final page = pages.values.first;

      if (page['thumbnail'] == null) return null;

      final content = page['extract']?.toString().trim() ?? '';
      if (content.isEmpty) return null;

      return WikiArticle(
        title: page['title'] ?? '',
        content: content,
        thumbnailUrl: page['thumbnail']?['source'],
      );
    } catch (e) {
      debugPrint('Article fetch error: $e');
      return null;
    }
  }

  // Belirli bir dil için makale çek
  static Future<List<WikiArticle>> _fetchArticlesForLang(String lang) async {
    final categories = List.of(_getCategoriesForLang(lang))..shuffle();

    final categoryResults = await Future.wait(
      categories.map((cat) => _fetchPageIdsFromCategory(cat, lang)),
    );

    final allPageIds = <int>[];
    for (final ids in categoryResults) {
      allPageIds.addAll(ids);
    }

    if (allPageIds.isEmpty) return [];

    allPageIds.shuffle();

    final List<WikiArticle> articles = [];
    int index = 0;

    // 10 fotoğraflı makale bulana kadar 5'er 5'er dene
    while (articles.length < 10 && index < allPageIds.length) {
      final batch = allPageIds.skip(index).take(5).toList();

      final results = await Future.wait(
        batch.map((id) => _fetchArticle(id, lang)),
      );

      // _fetchArticle zaten fotoğrafsızları null döndürüyor
      // whereType<WikiArticle>() null olanları otomatik eler
      articles.addAll(results.whereType<WikiArticle>());

      debugPrint('🔍 index: $index → toplam: ${articles.length}');
      index += 5;
    }

    return articles.take(10).toList();
  }

  // Ana fonksiyon
  static Future<List<WikiArticle>> fetchHistoryArticles() async {
    final lang = _getLanguageCode();
    debugPrint('🌍 Dil: $lang');

    // Önce cihaz dilinde dene
    List<WikiArticle> articles = await _fetchArticlesForLang(lang);
    debugPrint('📦 Cihaz dilinde gelen makale: ${articles.length}');

    // 5'ten az geldiyse tamamen İngilizce'ye geç
    if (articles.length < 5 && lang != 'en') {
      debugPrint('🔄 Yetersiz makale, tamamen EN\'e geçiliyor');
      articles = await _fetchArticlesForLang('en');
    }

    debugPrint('🎯 Toplam makale: ${articles.length}');
    return articles;
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

    try {
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
      ).timeout(const Duration(seconds: 60));

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final jsonString = responseBody['data'];
        final jsonObject = jsonDecode(jsonString);
        if (jsonObject is List) {
          icerikListesi = (jsonObject as List)
              .map((e) => ContentModel.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode} - ${response.body}');
      }

    } catch (e) {
      print('HATA: $e');
      rethrow; // hatayı yukarı ilet
    }

    /* final String languageCode = await getDeviceLanguageCode();
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
    } */

    return icerikListesi;

  }


  Future<String> getDeviceLanguageCode () async {

    final Locale deviceLocale = await PlatformDispatcher.instance.locales.first;

    return deviceLocale.languageCode;
  }


  static Future<Position> getUserLatLang() async {

    bool servicesEnabled;
    LocationPermission permission;

    servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return Future.error("Konum servisleri kapalı.");
    }
    /* else {
      return await Geolocator.getCurrentPosition();
    } */

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // İzin verilmemişse kullanıcıdan izin iste
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izni reddedildi.');
      }
    }

    return await Geolocator.getCurrentPosition();

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








