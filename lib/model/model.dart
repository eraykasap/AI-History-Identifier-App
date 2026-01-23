
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class ContentModel extends HiveObject {
  
  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  ContentModel({
    required this.title, 
    required this.content
  });

  factory ContentModel.fromMap(Map<String, dynamic> json) => ContentModel(
    title: json["Title"], 
    content: json["Explanation"]
  );

  


  @override
  String toString() {
    // TODO: implement toString
    return "ContentModel İD = ";
  }

}


@HiveType(typeId: 2)
class ContentSaveModel extends HiveObject {
  
  @HiveField(1)
  List<ContentModel> allContent = [];

  @HiveField(2)
  String imagePath = "";

  @HiveField(3)
  String Id = "";

  @HiveField(4)
  bool isSave = false;

  ContentSaveModel({required this.allContent, required this.imagePath, required this.Id, required this.isSave});

  //ContentSaveModel.kategori ({required this.allContent, required this.imagePath});

  File get image => File(imagePath);

  @override
  String toString() {
    // TODO: implement toString
    return "ContentSaveModel İD = $Id";
  }
  

}



class HistoricalPlace {
  
  final String name;
  final double lat;
  final double lang;

  HistoricalPlace({required this.name, required this.lat, required this.lang});

}



class StaticClass {
  

  static List<HistoricalPlace> place = [
    // türkiye
    HistoricalPlace(name: "Topkapı Sarayı", lat: 41.011592, lang: 28.983357),
    HistoricalPlace(name: "Ayasofya", lat: 41.008583, lang: 28.980178),
    HistoricalPlace(name: "Efes Antik Kenti", lat: 37.939453, lang: 27.340965),
    HistoricalPlace(name: "Anıtkabir", lat: 39.925148, lang: 32.837551),
    HistoricalPlace(name: "İstanbul Arkeoloji Müzesi", lat: 41.011488, lang: 28.981266),
    HistoricalPlace(name: "Dolmabahçe Sarayı", lat: 41.039200, lang: 29.000276),
    HistoricalPlace(name: "Kapalıçarşı", lat: 41.010833, lang: 28.968056),
    HistoricalPlace(name: "Pamukkale", lat: 37.920556, lang: 29.121111),
    HistoricalPlace(name: "Göbekli Tepe", lat: 37.223056, lang: 38.9225),
    HistoricalPlace(name: "Nemrut Dağı", lat: 37.980556, lang: 38.740833),
    HistoricalPlace(name: "Sümela Manastırı", lat: 40.689722, lang: 39.660556),
    HistoricalPlace(name: "Aspendos Antik Tiyatrosu", lat: 36.939167, lang: 31.172222),
    HistoricalPlace(name: "Pergamon Antik Kenti", lat: 39.131944, lang: 27.184444),
    HistoricalPlace(name: "Hierapolis", lat: 37.924167, lang: 29.125833),
    HistoricalPlace(name: "Cappadocia", lat: 38.641944, lang: 34.828611),
    HistoricalPlace(name: "Perge Antik Kenti", lat: 36.961111, lang: 30.854167),
    HistoricalPlace(name: "Troya Antik Kenti", lat: 39.957500, lang: 26.239167),
    HistoricalPlace(name: "Rumeli Hisarı", lat: 41.084167, lang: 29.056389),
    HistoricalPlace(name: "Çatalhöyük", lat: 37.666667, lang: 32.827778),
    HistoricalPlace(name: "Bodrum Kalesi", lat: 37.031944, lang: 27.429167),
    HistoricalPlace(name: "Mevlana Müzesi", lat: 37.871389, lang: 32.504722),
    HistoricalPlace(name: "Zeugma Mozaik Müzesi", lat: 37.058889, lang: 37.382778),
    HistoricalPlace(name: "Hagia Eirene", lat: 41.010000, lang: 28.980556),
    HistoricalPlace(name: "Kariye Müzesi", lat: 41.030833, lang: 28.938611),
    HistoricalPlace(name: "Sultanahmet Camii", lat: 41.005278, lang: 28.976944),
    HistoricalPlace(name: "Galata Kulesi", lat: 41.025556, lang: 28.974167),
    HistoricalPlace(name: "Yerebatan Sarnıcı", lat: 41.008333, lang: 28.977778),
    HistoricalPlace(name: "Anadolu Medeniyetleri Müzesi", lat: 39.940556, lang: 32.863889),

    // fransa
    HistoricalPlace(name: "Louvre Müzesi", lat: 48.860611, lang: 2.337644),
    HistoricalPlace(name: "Musée d'Orsay", lat: 48.859970, lang: 2.326553),
    HistoricalPlace(name: "Versay Sarayı", lat: 48.804865, lang: 2.120355),
    HistoricalPlace(name: "Centre Pompidou", lat: 48.860642, lang: 2.352245),
    HistoricalPlace(name: "Musée Rodin", lat: 48.855481, lang: 2.315896),
    HistoricalPlace(name: "Eyfel Kulesi", lat: 48.858370, lang: 2.294481),
    HistoricalPlace(name: "Notre-Dame", lat: 48.852968, lang: 2.349902),
    HistoricalPlace(name: "Arc de Triomphe", lat: 48.873792, lang: 2.295028),
    HistoricalPlace(name: "Musée de l'Orangerie", lat: 48.863889, lang: 2.322500),
    HistoricalPlace(name: "Sainte-Chapelle", lat: 48.855278, lang: 2.345),
    HistoricalPlace(name: "Musée Picasso", lat: 48.859722, lang: 2.362500),
    HistoricalPlace(name: "Panthéon", lat: 48.846222, lang: 2.346111),
    HistoricalPlace(name: "Les Invalides", lat: 48.855278, lang: 2.312500),
    HistoricalPlace(name: "Sacré-Cœur", lat: 48.886667, lang: 2.343056),
    HistoricalPlace(name: "Pont du Gard", lat: 43.947222, lang: 4.535556),
    HistoricalPlace(name: "Mont Saint-Michel", lat: 48.636111, lang: -1.511389),
    HistoricalPlace(name: "Château de Chambord", lat: 47.616389, lang: 1.517222),
    HistoricalPlace(name: "Palais des Papes", lat: 43.950833, lang: 4.807222),
    HistoricalPlace(name: "Musée Matisse", lat: 43.719444, lang: 7.266111),
    HistoricalPlace(name: "Carcassonne", lat: 43.206111, lang: 2.365278),
    HistoricalPlace(name: "Château de Chenonceau", lat: 47.324722, lang: 1.070278),
    HistoricalPlace(name: "Lascaux Caves", lat: 45.053889, lang: 1.166667),
    HistoricalPlace(name: "Musée Carnavalet", lat: 48.857222, lang: 2.362222),
    HistoricalPlace(name: "Conciergerie", lat: 48.856111, lang: 2.345833),
    HistoricalPlace(name: "Grand Palais", lat: 48.866111, lang: 2.312222),
    HistoricalPlace(name: "Petit Palais", lat: 48.866111, lang: 2.314444),
    HistoricalPlace(name: "Musée Guimet", lat: 48.865278, lang: 2.293611),
    HistoricalPlace(name: "Fontainebleau Palace", lat: 48.402222, lang: 2.700000),
    HistoricalPlace(name: "Musée de Cluny", lat: 48.850556, lang: 2.343333),
    HistoricalPlace(name: "Nîmes Arena", lat: 43.834444, lang: 4.360833),
    HistoricalPlace(name: "Arles Amphitheatre", lat: 43.677500, lang: 4.631389),
    HistoricalPlace(name: "Marseille History Museum", lat: 43.296389, lang: 5.374722),
    HistoricalPlace(name: "Strasbourg Cathedral", lat: 48.581944, lang: 7.751111),

    // ingiltere
    HistoricalPlace(name: "British Museum", lat: 51.519413, lang: -0.126957),
    HistoricalPlace(name: "National Gallery", lat: 51.508929, lang: -0.128299),
    HistoricalPlace(name: "Victoria and Albert Museum", lat: 51.496715, lang: -0.172169),
    HistoricalPlace(name: "Tate Modern", lat: 51.507577, lang: -0.099334),
    HistoricalPlace(name: "Natural History Museum", lat: 51.496715, lang: -0.176437),
    HistoricalPlace(name: "Tower of London", lat: 51.508112, lang: -0.075949),
    HistoricalPlace(name: "Buckingham Palace", lat: 51.501364, lang: -0.141890),
    HistoricalPlace(name: "Westminster Abbey", lat: 51.499479, lang: -0.127586),
    HistoricalPlace(name: "Science Museum", lat: 51.497806, lang: -0.174556),
    HistoricalPlace(name: "Stonehenge", lat: 51.178882, lang: -1.826215),
    HistoricalPlace(name: "Big Ben", lat: 51.500729, lang: -0.124625),
    HistoricalPlace(name: "St. Paul's Cathedral", lat: 51.513889, lang: -0.098056),
    HistoricalPlace(name: "Tate Britain", lat: 51.491111, lang: -0.127778),
    HistoricalPlace(name: "Windsor Castle", lat: 51.483611, lang: -0.604167),
    HistoricalPlace(name: "Roman Baths", lat: 51.381111, lang: -2.358889),
    HistoricalPlace(name: "Edinburgh Castle", lat: 55.948611, lang: -3.199722),
    HistoricalPlace(name: "National Museum Scotland", lat: 55.947222, lang: -3.190556),
    HistoricalPlace(name: "Ashmolean Museum", lat: 51.754722, lang: -1.259722),
    HistoricalPlace(name: "Imperial War Museum", lat: 51.495833, lang: -0.108611),
    HistoricalPlace(name: "Churchill War Rooms", lat: 51.501944, lang: -0.129444),
    HistoricalPlace(name: "Shakespeare's Globe", lat: 51.508056, lang: -0.097222),
    HistoricalPlace(name: "Kensington Palace", lat: 51.505278, lang: -0.187778),
    HistoricalPlace(name: "Hampton Court Palace", lat: 51.403333, lang: -0.337222),
    HistoricalPlace(name: "York Minster", lat: 53.962222, lang: -1.081667),
    HistoricalPlace(name: "National Railway Museum", lat: 53.961389, lang: -1.099167),

    // italya 
    HistoricalPlace(name: "Vatikan Müzeleri", lat: 41.906469, lang: 12.454331),
    HistoricalPlace(name: "Uffizi Galerisi", lat: 43.768387, lang: 11.255773),
    HistoricalPlace(name: "Kolezyum", lat: 41.890210, lang: 12.492231),
    HistoricalPlace(name: "Galleria Borghese", lat: 41.914249, lang: 12.492457),
    HistoricalPlace(name: "Pompeii Antik Kenti", lat: 40.751076, lang: 14.489663),
    HistoricalPlace(name: "Pisa Kulesi", lat: 43.722952, lang: 10.396597),
    HistoricalPlace(name: "Galleria dell'Accademia", lat: 43.776944, lang: 11.258889),
    HistoricalPlace(name: "Palazzo Ducale", lat: 45.433611, lang: 12.340556),
    HistoricalPlace(name: "Trevi Çeşmesi", lat: 41.900833, lang: 12.483056),
    HistoricalPlace(name: "Pantheon", lat: 41.898611, lang: 12.476944),
    HistoricalPlace(name: "Sistine Chapel", lat: 41.903056, lang: 12.454444),
    HistoricalPlace(name: "Duomo di Milano", lat: 45.464167, lang: 9.191944),
    HistoricalPlace(name: "Venice Canals", lat: 45.438611, lang: 12.327222),
    HistoricalPlace(name: "Piazza San Marco", lat: 45.434167, lang: 12.338333),
    HistoricalPlace(name: "Palazzo Pitti", lat: 43.765000, lang: 11.250000),
    HistoricalPlace(name: "Castel Sant'Angelo", lat: 41.903056, lang: 12.466111),
    HistoricalPlace(name: "Roman Forum", lat: 41.892500, lang: 12.485278),
    HistoricalPlace(name: "Cinque Terre", lat: 44.138056, lang: 9.710278),
    HistoricalPlace(name: "Amalfi Coast", lat: 40.633333, lang: 14.602778),
    HistoricalPlace(name: "Capitoline Museums", lat: 41.893056, lang: 12.482778),
    HistoricalPlace(name: "Basilica di San Pietro", lat: 41.902222, lang: 12.453889),
    HistoricalPlace(name: "Herculaneum", lat: 40.806111, lang: 14.348056),
    HistoricalPlace(name: "Doge's Palace", lat: 45.433889, lang: 12.340556),
    HistoricalPlace(name: "Ponte Vecchio", lat: 43.768056, lang: 11.253056),
    HistoricalPlace(name: "Boboli Gardens", lat: 43.762222, lang: 11.250000),
    HistoricalPlace(name: "Villa Borghese", lat: 41.914167, lang: 12.492222),
    HistoricalPlace(name: "Teatro alla Scala", lat: 45.467222, lang: 9.189444),
    HistoricalPlace(name: "Siena Cathedral", lat: 43.317778, lang: 11.329444),
    HistoricalPlace(name: "San Gimignano", lat: 43.467778, lang: 11.043056),
    HistoricalPlace(name: "Verona Arena", lat: 45.439167, lang: 10.994722),
    HistoricalPlace(name: "Lake Como", lat: 45.995833, lang: 9.263889),

    // ispanya
    HistoricalPlace(name: "Prado Müzesi", lat: 40.413792, lang: -3.692280),
    HistoricalPlace(name: "Sagrada Familia", lat: 41.403629, lang: 2.174356),
    HistoricalPlace(name: "Reina Sofía Müzesi", lat: 40.407945, lang: -3.693707),
    HistoricalPlace(name: "Alhambra", lat: 37.176512, lang: -3.588426),
    HistoricalPlace(name: "Guggenheim Bilbao", lat: 43.268719, lang: -2.939450),
    HistoricalPlace(name: "Park Güell", lat: 41.414495, lang: 2.152695),
    HistoricalPlace(name: "Royal Palace Madrid", lat: 40.417955, lang: -3.714312),
    HistoricalPlace(name: "Mezquita de Córdoba", lat: 37.878889, lang: -4.779444),
    HistoricalPlace(name: "Picasso Museum Barcelona", lat: 41.385063, lang: 2.180778),
    HistoricalPlace(name: "Santiago de Compostela", lat: 42.880556, lang: -8.544722),
    HistoricalPlace(name: "Casa Batlló", lat: 41.391667, lang: 2.165000),
    HistoricalPlace(name: "La Rambla", lat: 41.381944, lang: 2.170833),
    HistoricalPlace(name: "Seville Cathedral", lat: 37.385833, lang: -5.993056),
    HistoricalPlace(name: "Alcázar of Seville", lat: 37.383611, lang: -5.990833),
    HistoricalPlace(name: "Plaza Mayor Madrid", lat: 40.415556, lang: -3.707222),
    HistoricalPlace(name: "Retiro Park", lat: 40.415278, lang: -3.683889),
    HistoricalPlace(name: "Thyssen Museum", lat: 40.416111, lang: -3.694722),
    HistoricalPlace(name: "Camp Nou", lat: 41.380833, lang: 2.122778),
    HistoricalPlace(name: "Montjuïc", lat: 41.363889, lang: 2.165278),
    HistoricalPlace(name: "Girona Cathedral", lat: 41.987222, lang: 2.825833),
    HistoricalPlace(name: "Toledo Cathedral", lat: 39.857500, lang: -4.024167),
    HistoricalPlace(name: "Segovia Aqueduct", lat: 40.947778, lang: -4.117778),
    HistoricalPlace(name: "Burgos Cathedral", lat: 42.340556, lang: -3.704444),
    HistoricalPlace(name: "Valencia Cathedral", lat: 39.475556, lang: -0.375278),
    HistoricalPlace(name: "Ronda Bridge", lat: 36.741389, lang: -5.165278),
    HistoricalPlace(name: "Cuenca Hanging Houses", lat: 40.079444, lang: -2.131667),
    HistoricalPlace(name: "Ibiza Old Town", lat: 38.907778, lang: 1.432778),

    // almanya
    HistoricalPlace(name: "Pergamon Müzesi", lat: 52.521074, lang: 13.396577),
    HistoricalPlace(name: "Neues Museum", lat: 52.520889, lang: 13.397778),
    HistoricalPlace(name: "Deutsches Museum", lat: 48.129944, lang: 11.583583),
    HistoricalPlace(name: "BMW Museum", lat: 48.176818, lang: 11.559490),
    HistoricalPlace(name: "Brandenburg Kapısı", lat: 52.516275, lang: 13.377704),
    HistoricalPlace(name: "Neuschwanstein Kalesi", lat: 47.557574, lang: 10.749800),
    HistoricalPlace(name: "Kölner Dom", lat: 50.941357, lang: 6.958307),
    HistoricalPlace(name: "Altes Museum", lat: 52.519444, lang: 13.398611),
    HistoricalPlace(name: "Mercedes-Benz Museum", lat: 48.788611, lang: 9.232778),
    HistoricalPlace(name: "Reichstag", lat: 52.518611, lang: 13.376111),
    HistoricalPlace(name: "Checkpoint Charlie", lat: 52.507500, lang: 13.390278),
    HistoricalPlace(name: "Berlin Wall Memorial", lat: 52.535278, lang: 13.389722),
    HistoricalPlace(name: "Zwinger Palace", lat: 51.053333, lang: 13.734722),
    HistoricalPlace(name: "Heidelberg Castle", lat: 49.410556, lang: 8.715278),
    HistoricalPlace(name: "Rothenburg ob der Tauber", lat: 49.377778, lang: 10.178889),
    HistoricalPlace(name: "Nuremberg Castle", lat: 49.457778, lang: 11.075556),
    HistoricalPlace(name: "Alte Pinakothek", lat: 48.148333, lang: 11.570000),
    HistoricalPlace(name: "Black Forest", lat: 48.165833, lang: 8.130556),
    HistoricalPlace(name: "Sanssouci Palace", lat: 52.403889, lang: 13.038056),
    HistoricalPlace(name: "Miniatur Wunderland", lat: 53.543889, lang: 9.988889),
    HistoricalPlace(name: "Topography of Terror", lat: 52.506667, lang: 13.382778),
    HistoricalPlace(name: "Jewish Museum Berlin", lat: 52.502222, lang: 13.395000),
    HistoricalPlace(name: "Charlottenburg Palace", lat: 52.520556, lang: 13.295833),
    HistoricalPlace(name: "Frauenkirche Dresden", lat: 51.051944, lang: 13.741389),
    HistoricalPlace(name: "Marienplatz Munich", lat: 48.137222, lang: 11.575556),
    HistoricalPlace(name: "Hamburg Kunsthalle", lat: 53.554167, lang: 10.001389),
    HistoricalPlace(name: "Rhine Valley", lat: 50.354722, lang: 7.591667),
    HistoricalPlace(name: "Aachen Cathedral", lat: 50.774722, lang: 6.083889),
    HistoricalPlace(name: "Bauhaus Museum", lat: 51.964722, lang: 7.626111),

    // amerika
    HistoricalPlace(name: "Metropolitan Museum", lat: 40.779437, lang: -73.963244),
    HistoricalPlace(name: "MoMA", lat: 40.761433, lang: -73.977622),
    HistoricalPlace(name: "Empire State Building", lat: 40.748817, lang: -73.985428),
    HistoricalPlace(name: "Statue of Liberty", lat: 40.689247, lang: -74.044502),
    HistoricalPlace(name: "Central Park", lat: 40.785091, lang: -73.968285),
    HistoricalPlace(name: "Times Square", lat: 40.758896, lang: -73.985130),
    HistoricalPlace(name: "Brooklyn Bridge", lat: 40.706086, lang: -73.996864),
    HistoricalPlace(name: "9/11 Memorial", lat: 40.711512, lang: -74.013224),
    HistoricalPlace(name: "American Museum Natural History", lat: 40.781324, lang: -73.973988),
    HistoricalPlace(name: "Guggenheim Museum", lat: 40.782865, lang: -73.958970),
    HistoricalPlace(name: "One World Observatory", lat: 40.713005, lang: -74.013169),
    HistoricalPlace(name: "Rockefeller Center", lat: 40.758679, lang: -73.978848),
    HistoricalPlace(name: "Smithsonian National Museum", lat: 38.891266, lang: -77.026065),
    HistoricalPlace(name: "White House", lat: 38.897676, lang: -77.036530),
    HistoricalPlace(name: "National Gallery of Art", lat: 38.891266, lang: -77.019974),
    HistoricalPlace(name: "Washington Monument", lat: 38.889722, lang: -77.035278),
    HistoricalPlace(name: "Lincoln Memorial", lat: 38.889269, lang: -77.050176),
    HistoricalPlace(name: "National Air and Space", lat: 38.888056, lang: -77.019722),
    HistoricalPlace(name: "US Capitol", lat: 38.889931, lang: -77.009003),
    HistoricalPlace(name: "Jefferson Memorial", lat: 38.881389, lang: -77.036667),
    HistoricalPlace(name: "Arlington Cemetery", lat: 38.877778, lang: -77.067222),
    HistoricalPlace(name: "Vietnam Veterans Memorial", lat: 38.891111, lang: -77.047778),
    HistoricalPlace(name: "Getty Center", lat: 34.078062, lang: -118.473892),
    HistoricalPlace(name: "Golden Gate Bridge", lat: 37.819929, lang: -122.478255),
    HistoricalPlace(name: "Alcatraz Island", lat: 37.826944, lang: -122.423056),
    HistoricalPlace(name: "Hollywood Sign", lat: 34.134117, lang: -118.321495),
    HistoricalPlace(name: "Disneyland", lat: 33.812092, lang: -117.918974),
    HistoricalPlace(name: "Universal Studios", lat: 34.138250, lang: -118.353333),
    HistoricalPlace(name: "Yosemite", lat: 37.865101, lang: -119.538330),
    HistoricalPlace(name: "San Diego Zoo", lat: 32.735278, lang: -117.149444),
    HistoricalPlace(name: "Death Valley", lat: 36.505556, lang: -116.932222),
    HistoricalPlace(name: "Sequoia National Park", lat: 36.486389, lang: -118.565556),
    HistoricalPlace(name: "Joshua Tree", lat: 33.873415, lang: -115.900993),
    HistoricalPlace(name: "Santa Monica Pier", lat: 34.008611, lang: -118.498889),
    HistoricalPlace(name: "Griffith Observatory", lat: 34.118500, lang: -118.300389),
    HistoricalPlace(name: "Venice Beach", lat: 33.985556, lang: -118.472778),
    HistoricalPlace(name: "Fisherman's Wharf", lat: 37.808333, lang: -122.415556),
    HistoricalPlace(name: "Art Institute of Chicago", lat: 41.879585, lang: -87.623713),
    HistoricalPlace(name: "Willis Tower", lat: 41.878876, lang: -87.635915),
    HistoricalPlace(name: "Navy Pier", lat: 41.891667, lang: -87.605556),
    HistoricalPlace(name: "Millennium Park", lat: 41.882702, lang: -87.622554),
    HistoricalPlace(name: "Field Museum", lat: 41.866250, lang: -87.617028),
    HistoricalPlace(name: "Shedd Aquarium", lat: 41.867778, lang: -87.614167),
    HistoricalPlace(name: "Independence Hall", lat: 39.948889, lang: -75.150000),
    HistoricalPlace(name: "Liberty Bell", lat: 39.949611, lang: -75.150278),
    HistoricalPlace(name: "Philadelphia Museum of Art", lat: 39.965556, lang: -75.180833),
    HistoricalPlace(name: "Gettysburg Battlefield", lat: 39.820833, lang: -77.231111),
    HistoricalPlace(name: "Boston Museum of Fine Arts", lat: 42.339381, lang: -71.094048),
    HistoricalPlace(name: "Freedom Trail", lat: 42.360833, lang: -71.056944),
    HistoricalPlace(name: "Harvard University", lat: 42.377000, lang: -71.116389),
    HistoricalPlace(name: "Fenway Park", lat: 42.346676, lang: -71.097218),
    HistoricalPlace(name: "USS Constitution", lat: 42.372222, lang: -71.056111),
    HistoricalPlace(name: "Walt Disney World", lat: 28.385233, lang: -81.563874),
    HistoricalPlace(name: "Kennedy Space Center", lat: 28.573469, lang: -80.651070),
    HistoricalPlace(name: "Everglades National Park", lat: 25.286944, lang: -80.898889),
    HistoricalPlace(name: "Miami Beach", lat: 25.790654, lang: -80.130045),
    HistoricalPlace(name: "Key West", lat: 24.555059, lang: -81.779984),
    HistoricalPlace(name: "Las Vegas Strip", lat: 36.114647, lang: -115.172813),
    HistoricalPlace(name: "Hoover Dam", lat: 36.015556, lang: -114.737222),
    HistoricalPlace(name: "Grand Canyon", lat: 36.106965, lang: -112.112997),
    HistoricalPlace(name: "Antelope Canyon", lat: 36.861944, lang: -111.374167),
    HistoricalPlace(name: "Monument Valley", lat: 36.998056, lang: -110.098889),
    HistoricalPlace(name: "Sedona Red Rocks", lat: 34.869815, lang: -111.761047),
    HistoricalPlace(name: "Space Needle", lat: 47.620422, lang: -122.349358),
    HistoricalPlace(name: "Pike Place Market", lat: 47.608889, lang: -122.340556),
    HistoricalPlace(name: "Mount Rainier", lat: 46.852947, lang: -121.760424),
    HistoricalPlace(name: "Yellowstone", lat: 44.427963, lang: -110.588455),
    HistoricalPlace(name: "Grand Teton", lat: 43.790427, lang: -110.681733),
    HistoricalPlace(name: "Old Faithful", lat: 44.460556, lang: -110.828056),
    HistoricalPlace(name: "Glacier National Park", lat: 48.759613, lang: -113.787022),
    HistoricalPlace(name: "Pearl Harbor", lat: 21.364861, lang: -157.950806),
    HistoricalPlace(name: "Diamond Head", lat: 21.259167, lang: -157.805556),
    HistoricalPlace(name: "Haleakalā Crater", lat: 20.709722, lang: -156.253333),
    HistoricalPlace(name: "The Alamo", lat: 29.425139, lang: -98.486111),
    HistoricalPlace(name: "Space Center Houston", lat: 29.551944, lang: -95.097778),
    HistoricalPlace(name: "Big Bend National Park", lat: 29.250000, lang: -103.250000),
    HistoricalPlace(name: "Arches National Park", lat: 38.733333, lang: -109.592778),
    HistoricalPlace(name: "Zion National Park", lat: 37.298333, lang: -113.026389),
    HistoricalPlace(name: "Bryce Canyon", lat: 37.593056, lang: -112.167778),
    HistoricalPlace(name: "Carlsbad Caverns", lat: 32.174722, lang: -104.443889),
    HistoricalPlace(name: "White Sands", lat: 32.779444, lang: -106.171389),
    HistoricalPlace(name: "Graceland", lat: 35.047500, lang: -90.025833),
    HistoricalPlace(name: "Great Smoky Mountains", lat: 35.611944, lang: -83.489444),
    HistoricalPlace(name: "French Quarter", lat: 29.958333, lang: -90.066667),
    HistoricalPlace(name: "Bourbon Street", lat: 29.963889, lang: -90.067778),
    HistoricalPlace(name: "Crater Lake", lat: 42.944722, lang: -122.109444),

    // mısır
    HistoricalPlace(name: "Mısır Müzesi", lat: 30.047778, lang: 31.233333),
    HistoricalPlace(name: "Giza Piramitleri", lat: 29.979175, lang: 31.134358),
    HistoricalPlace(name: "Karnak Tapınağı", lat: 25.718817, lang: 32.657375),
    HistoricalPlace(name: "Luxor Tapınağı", lat: 25.699583, lang: 32.639167),
    HistoricalPlace(name: "Abu Simbel", lat: 22.337222, lang: 31.625833),
    HistoricalPlace(name: "Sfenks", lat: 29.975278, lang: 31.137500),
    HistoricalPlace(name: "Krallar Vadisi", lat: 25.740278, lang: 32.601389),
    HistoricalPlace(name: "Philae Tapınağı", lat: 24.025556, lang: 32.885556),
    HistoricalPlace(name: "Saqqara", lat: 29.871111, lang: 31.216667),
    HistoricalPlace(name: "Alexandria Library", lat: 31.208333, lang: 29.909167),
    HistoricalPlace(name: "Hatshepsut Tapınağı", lat: 25.738056, lang: 32.605833),
    HistoricalPlace(name: "Edfu Tapınağı", lat: 24.977778, lang: 32.873889),
    HistoricalPlace(name: "Kom Ombo", lat: 24.451667, lang: 32.926111),
    HistoricalPlace(name: "Dendera Temple", lat: 26.141667, lang: 32.670833),
    HistoricalPlace(name: "Citadel of Cairo", lat: 30.029444, lang: 31.260000),
    HistoricalPlace(name: "Khan el-Khalili", lat: 30.047778, lang: 31.262500),
    HistoricalPlace(name: "Muhammad Ali Mosque", lat: 30.028333, lang: 31.260278),
    HistoricalPlace(name: "Dahshur", lat: 29.790556, lang: 31.230000),
    HistoricalPlace(name: "Colossi of Memnon", lat: 25.720556, lang: 32.610278),
    HistoricalPlace(name: "Siwa Oasis", lat: 29.203056, lang: 25.519444),
    HistoricalPlace(name: "White Desert", lat: 27.401944, lang: 27.947500),
    HistoricalPlace(name: "Montaza Palace", lat: 31.289167, lang: 30.017222),

    // yunanistan
    HistoricalPlace(name: "Akropolis Müzesi", lat: 37.968525, lang: 23.728083),
    HistoricalPlace(name: "Parthenon", lat: 37.971536, lang: 23.726817),
    HistoricalPlace(name: "Ulusal Arkeoloji Müzesi", lat: 37.989167, lang: 23.732778),
    HistoricalPlace(name: "Delphi Antik Kenti", lat: 38.482500, lang: 22.501111),
    HistoricalPlace(name: "Olympia Antik Kenti", lat: 37.638056, lang: 21.630000),
    HistoricalPlace(name: "Knossos Sarayı", lat: 35.297778, lang: 25.163056),
    HistoricalPlace(name: "Meteora Manastırları", lat: 39.721389, lang: 21.631111),
    HistoricalPlace(name: "Ancient Agora", lat: 37.975278, lang: 23.722222),
    HistoricalPlace(name: "Temple of Poseidon", lat: 37.651111, lang: 24.023333),
    HistoricalPlace(name: "Rhodes Colossus", lat: 36.434444, lang: 28.227222),
    HistoricalPlace(name: "Santorini", lat: 36.393156, lang: 25.461509),
    HistoricalPlace(name: "Mykonos", lat: 37.446667, lang: 25.329444),
    HistoricalPlace(name: "Temple of Hephaestus", lat: 37.975556, lang: 23.721667),
    HistoricalPlace(name: "Epidaurus Theatre", lat: 37.595833, lang: 23.079722),
    HistoricalPlace(name: "Corinth Canal", lat: 37.935278, lang: 22.984444),
    HistoricalPlace(name: "Mystras", lat: 37.071111, lang: 22.371944),
    HistoricalPlace(name: "Thessaloniki White Tower", lat: 40.626389, lang: 22.948333),
    HistoricalPlace(name: "Palace of the Grand Master", lat: 36.445278, lang: 28.224167),
    HistoricalPlace(name: "Benaki Museum", lat: 37.975000, lang: 23.741111),
    HistoricalPlace(name: "Byzantine Museum", lat: 37.974722, lang: 23.742500),
    HistoricalPlace(name: "Ancient Corinth", lat: 37.906389, lang: 22.879167),
    HistoricalPlace(name: "Nafplio", lat: 37.567778, lang: 22.805556),
    HistoricalPlace(name: "Acropolis of Lindos", lat: 36.092500, lang: 28.086667),
    HistoricalPlace(name: "Samaria Gorge", lat: 35.296111, lang: 23.966389),

    // japonya
    HistoricalPlace(name: "Tokyo National Museum", lat: 35.719028, lang: 139.776278),
    HistoricalPlace(name: "Kyoto National Museum", lat: 34.987778, lang: 135.772222),
    HistoricalPlace(name: "Hiroshima Peace Memorial", lat: 34.395483, lang: 132.453592),
    HistoricalPlace(name: "Fushimi Inari Tapınağı", lat: 34.967146, lang: 135.772695),
    HistoricalPlace(name: "Himeji Kalesi", lat: 34.839444, lang: 134.693889),
    HistoricalPlace(name: "Tokyo Skytree", lat: 35.710063, lang: 139.810775),
    HistoricalPlace(name: "Kinkaku-ji", lat: 35.039444, lang: 135.729167),
    HistoricalPlace(name: "Senso-ji Temple", lat: 35.714722, lang: 139.796667),
    HistoricalPlace(name: "Nara Park", lat: 34.685000, lang: 135.843333),
    HistoricalPlace(name: "Mount Fuji", lat: 35.360556, lang: 138.727500),
    HistoricalPlace(name: "Tokyo Imperial Palace", lat: 35.685175, lang: 139.752799),
    HistoricalPlace(name: "Meiji Shrine", lat: 35.676111, lang: 139.699444),
    HistoricalPlace(name: "Kiyomizu-dera", lat: 34.994722, lang: 135.785000),
    HistoricalPlace(name: "Osaka Castle", lat: 34.687315, lang: 135.526201),
    HistoricalPlace(name: "Arashiyama Bamboo Grove", lat: 35.009722, lang: 135.670556),
    HistoricalPlace(name: "Todai-ji Temple", lat: 34.689167, lang: 135.839722),
    HistoricalPlace(name: "Itsukushima Shrine", lat: 34.295833, lang: 132.319722),
    HistoricalPlace(name: "Nikko Toshogu", lat: 36.757778, lang: 139.598889),
    HistoricalPlace(name: "Shibuya Crossing", lat: 35.659444, lang: 139.700556),
    HistoricalPlace(name: "Gion District", lat: 35.003056, lang: 135.775833),
    HistoricalPlace(name: "Kamakura Buddha", lat: 35.316667, lang: 139.536111),
    HistoricalPlace(name: "Nagasaki Peace Park", lat: 32.776111, lang: 129.863056),
    HistoricalPlace(name: "Hokkaido Shrine", lat: 43.065556, lang: 141.356944),
    HistoricalPlace(name: "Ryoan-ji Temple", lat: 35.034444, lang: 135.718333),
    HistoricalPlace(name: "Ginkaku-ji", lat: 35.027222, lang: 135.798056),
    HistoricalPlace(name: "Matsumoto Castle", lat: 36.238333, lang: 137.968889),

    // çin
    HistoricalPlace(name: "Forbidden City", lat: 39.916668, lang: 116.390556),
    HistoricalPlace(name: "Çin Seddi", lat: 40.431908, lang: 116.570374),
    HistoricalPlace(name: "Terracotta Warriors Museum", lat: 34.384722, lang: 109.278611),
    HistoricalPlace(name: "Shanghai Museum", lat: 31.228611, lang: 121.475),
    HistoricalPlace(name: "Summer Palace", lat: 39.999722, lang: 116.275278),
    HistoricalPlace(name: "Temple of Heaven", lat: 39.882222, lang: 116.407222),
    HistoricalPlace(name: "Potala Palace", lat: 29.655833, lang: 91.117222),
    HistoricalPlace(name: "Li River", lat: 25.273611, lang: 110.290278),
    HistoricalPlace(name: "Leshan Giant Buddha", lat: 29.545556, lang: 103.771111),
    HistoricalPlace(name: "Zhangjiajie National Park", lat: 29.316667, lang: 110.479167),
    HistoricalPlace(name: "Bund Shanghai", lat: 31.239722, lang: 121.490556),
    HistoricalPlace(name: "West Lake", lat: 30.243611, lang: 120.141389),
    HistoricalPlace(name: "Lijiang Old Town", lat: 26.877500, lang: 100.227778),
    HistoricalPlace(name: "Yellow Mountains", lat: 30.133333, lang: 118.150000),
    HistoricalPlace(name: "Longmen Grottoes", lat: 34.550000, lang: 112.466667),
    HistoricalPlace(name: "Shaolin Temple", lat: 34.505556, lang: 112.932778),
    HistoricalPlace(name: "Giant Panda Base", lat: 30.737778, lang: 104.148889),
    HistoricalPlace(name: "Yungang Grottoes", lat: 40.110000, lang: 113.135000),
    HistoricalPlace(name: "Tiananmen Square", lat: 39.903889, lang: 116.397222),
    HistoricalPlace(name: "Victoria Harbour", lat: 22.287778, lang: 114.170556),
    HistoricalPlace(name: "Oriental Pearl Tower", lat: 31.239722, lang: 121.499444),
    HistoricalPlace(name: "Jade Buddha Temple", lat: 31.244167, lang: 121.442222),
    HistoricalPlace(name: "Mogao Caves", lat: 40.040000, lang: 94.803333),
    HistoricalPlace(name: "Jiuzhaigou Valley", lat: 33.260000, lang: 103.918333),
    HistoricalPlace(name: "Tiger Leaping Gorge", lat: 27.195556, lang: 100.119444),
    HistoricalPlace(name: "Huangshan", lat: 30.133333, lang: 118.166667),
    HistoricalPlace(name: "Three Gorges Dam", lat: 30.823056, lang: 111.003333),
    HistoricalPlace(name: "Shilin Stone Forest", lat: 24.813889, lang: 103.348889),
    HistoricalPlace(name: "Mount Emei", lat: 29.544167, lang: 103.347778),
    HistoricalPlace(name: "Pingyao Ancient City", lat: 37.190278, lang: 112.181389),

    // hollanda
    HistoricalPlace(name: "Rijksmuseum", lat: 52.360001, lang: 4.885278),
    HistoricalPlace(name: "Van Gogh Museum", lat: 52.358417, lang: 4.881111),
    HistoricalPlace(name: "Anne Frank Evi", lat: 52.375217, lang: 4.883976),
    HistoricalPlace(name: "Mauritshuis", lat: 52.080555, lang: 4.313889),
    HistoricalPlace(name: "Stedelijk Museum", lat: 52.358056, lang: 4.879722),
    HistoricalPlace(name: "Keukenhof", lat: 52.270278, lang: 4.546944),
    HistoricalPlace(name: "Dam Square", lat: 52.373056, lang: 4.893333),
    HistoricalPlace(name: "Kinderdijk Windmills", lat: 51.883889, lang: 4.640278),
    HistoricalPlace(name: "Rembrandt House Museum", lat: 52.369444, lang: 4.901667),
    HistoricalPlace(name: "Royal Palace Amsterdam", lat: 52.373056, lang: 4.890833),
    HistoricalPlace(name: "Vondelpark", lat: 52.358056, lang: 4.868333),
    HistoricalPlace(name: "Heineken Experience", lat: 52.357778, lang: 4.892222),
    HistoricalPlace(name: "Zaanse Schans", lat: 52.472778, lang: 4.817500),
    HistoricalPlace(name: "Madurodam", lat: 52.099167, lang: 4.301667),
    HistoricalPlace(name: "Rotterdam Markthal", lat: 51.920000, lang: 4.485833),
    HistoricalPlace(name: "Cube Houses", lat: 51.920000, lang: 4.490556),
    HistoricalPlace(name: "Peace Palace", lat: 52.087222, lang: 4.295833),
    HistoricalPlace(name: "Delft Blue Pottery", lat: 52.011944, lang: 4.357222),
    HistoricalPlace(name: "Giethoorn", lat: 52.738611, lang: 6.076667),
    HistoricalPlace(name: "Utrecht Dom Tower", lat: 52.090833, lang: 5.121389),

    // rusya
    HistoricalPlace(name: "Hermitage Museum", lat: 59.939861, lang: 30.314444),
    HistoricalPlace(name: "Kremlin", lat: 55.752121, lang: 37.617664),
    HistoricalPlace(name: "Tretyakov Gallery", lat: 55.741389, lang: 37.620556),
    HistoricalPlace(name: "Peterhof Sarayı", lat: 59.885556, lang: 29.908889),
    HistoricalPlace(name: "Catherine Palace", lat: 59.715833, lang: 30.395833),
    HistoricalPlace(name: "St. Basil's Cathedral", lat: 55.752500, lang: 37.623056),
    HistoricalPlace(name: "Red Square", lat: 55.753889, lang: 37.620833),
    HistoricalPlace(name: "Church of the Savior", lat: 59.940278, lang: 30.328611),
    HistoricalPlace(name: "Bolshoi Theatre", lat: 55.760278, lang: 37.618889),
    HistoricalPlace(name: "Pushkin Museum", lat: 55.747500, lang: 37.604444),
    HistoricalPlace(name: "GUM Department Store", lat: 55.754722, lang: 37.621389),
    HistoricalPlace(name: "Novodevichy Convent", lat: 55.726667, lang: 37.556111),
    HistoricalPlace(name: "Izmailovo Kremlin", lat: 55.796111, lang: 37.749722),
    HistoricalPlace(name: "Lenin's Mausoleum", lat: 55.753611, lang: 37.619722),
    HistoricalPlace(name: "Moscow Metro", lat: 55.751667, lang: 37.617778),
    HistoricalPlace(name: "Kazan Cathedral", lat: 59.934167, lang: 30.324444),
    HistoricalPlace(name: "Mariinsky Theatre", lat: 59.925833, lang: 30.295833),
    HistoricalPlace(name: "Peter and Paul Fortress", lat: 59.950000, lang: 30.316667),
    HistoricalPlace(name: "Russian Museum", lat: 59.937778, lang: 30.333056),
    HistoricalPlace(name: "Fabergé Museum", lat: 59.938333, lang: 30.339722),
    HistoricalPlace(name: "Lake Baikal", lat: 53.558333, lang: 108.165278),
    HistoricalPlace(name: "Trans-Siberian Railway", lat: 55.755833, lang: 37.617778),
    HistoricalPlace(name: "Kizhi Island", lat: 62.066667, lang: 35.233333),

    // avustralya
    HistoricalPlace(name: "Australian Museum", lat: -33.874444, lang: 151.212778),
    HistoricalPlace(name: "National Gallery of Australia", lat: -35.296667, lang: 149.135),
    HistoricalPlace(name: "Sydney Opera House", lat: -33.856784, lang: 151.215297),
    HistoricalPlace(name: "Melbourne Museum", lat: -37.803333, lang: 144.971667),
    HistoricalPlace(name: "Museum of Old and New Art", lat: -42.836111, lang: 147.250278),
    HistoricalPlace(name: "Sydney Harbour Bridge", lat: -33.852222, lang: 151.210556),
    HistoricalPlace(name: "Great Barrier Reef", lat: -18.286111, lang: 147.700000),
    HistoricalPlace(name: "Uluru", lat: -25.344444, lang: 131.036111),
    HistoricalPlace(name: "Royal Exhibition Building", lat: -37.804722, lang: 144.971944),
    HistoricalPlace(name: "Port Arthur Historic Site", lat: -43.146667, lang: 147.851944),
    HistoricalPlace(name: "Bondi Beach", lat: -33.890833, lang: 151.274722),
    HistoricalPlace(name: "Blue Mountains", lat: -33.711111, lang: 150.311944),
    HistoricalPlace(name: "Twelve Apostles", lat: -38.665833, lang: 143.104722),
    HistoricalPlace(name: "Kakadu National Park", lat: -12.654722, lang: 132.418889),
    HistoricalPlace(name: "Daintree Rainforest", lat: -16.170278, lang: 145.417222),
    HistoricalPlace(name: "Federation Square", lat: -37.817778, lang: 144.968889),
    HistoricalPlace(name: "Queen Victoria Market", lat: -37.807222, lang: 144.957222),
    HistoricalPlace(name: "Taronga Zoo", lat: -33.843056, lang: 151.241111),

    // berzilya
    HistoricalPlace(name: "Museu do Ipiranga", lat: -23.585278, lang: -46.609722),
    HistoricalPlace(name: "Museu Nacional", lat: -22.905833, lang: -43.226111),
    HistoricalPlace(name: "Cristo Redentor", lat: -22.951944, lang: -43.210556),
    HistoricalPlace(name: "MASP", lat: -23.561389, lang: -46.655833),
    HistoricalPlace(name: "Museu de Arte Moderna", lat: -22.916389, lang: -43.175833),
    HistoricalPlace(name: "Sugarloaf Mountain", lat: -22.948889, lang: -43.157222),
    HistoricalPlace(name: "Copacabana Beach", lat: -22.971111, lang: -43.182778),
    HistoricalPlace(name: "Amazon Rainforest", lat: -3.465305, lang: -62.215881),
    HistoricalPlace(name: "Iguazu Falls", lat: -25.695278, lang: -54.436667),
    HistoricalPlace(name: "Pelourinho Salvador", lat: -12.971667, lang: -38.510278),
    HistoricalPlace(name: "Ipanema Beach", lat: -22.986944, lang: -43.206389),
    HistoricalPlace(name: "Lapa Arches", lat: -22.913056, lang: -43.179444),
    HistoricalPlace(name: "Botanical Garden Rio", lat: -22.967222, lang: -43.224444),
    HistoricalPlace(name: "Ouro Preto", lat: -20.386111, lang: -43.503889),
    HistoricalPlace(name: "Pantanal", lat: -17.820000, lang: -57.484167),
    HistoricalPlace(name: "Fernando de Noronha", lat: -3.854167, lang: -32.426944),
    HistoricalPlace(name: "Ibirapuera Park", lat: -23.587500, lang: -46.657778),
    HistoricalPlace(name: "Teatro Amazonas", lat: -3.130556, lang: -60.022778),
    HistoricalPlace(name: "Catedral Metropolitana", lat: -22.909444, lang: -43.177778),
    HistoricalPlace(name: "Escadaria Selaron", lat: -22.914722, lang: -43.179167),
    HistoricalPlace(name: "São Paulo Cathedral", lat: -23.550556, lang: -46.633889),

    // belçika
    HistoricalPlace(name: "Royal Museums of Fine Arts", lat: 50.842222, lang: 4.358056),
    HistoricalPlace(name: "Atomium", lat: 50.894941, lang: 4.341547),
    HistoricalPlace(name: "Grand Place Brussels", lat: 50.846667, lang: 4.352222),
    HistoricalPlace(name: "Manneken Pis", lat: 50.845000, lang: 4.350000),
    HistoricalPlace(name: "Mini-Europe", lat: 50.894167, lang: 4.341389),
    HistoricalPlace(name: "Gravensteen Castle", lat: 51.057222, lang: 3.720556),
    HistoricalPlace(name: "Belfry of Bruges", lat: 51.208333, lang: 3.224444),
    HistoricalPlace(name: "Basilica of the Holy Blood", lat: 51.208056, lang: 3.226667),
    HistoricalPlace(name: "St. Bavo's Cathedral", lat: 51.053611, lang: 3.726111),
    HistoricalPlace(name: "Museum aan de Stroom", lat: 51.229167, lang: 4.403056),
    HistoricalPlace(name: "Royal Palace Brussels", lat: 50.842222, lang: 4.362778),
    HistoricalPlace(name: "Rubens House", lat: 51.217778, lang: 4.405833),
    HistoricalPlace(name: "Horta Museum", lat: 50.827500, lang: 4.343056),
    HistoricalPlace(name: "Magritte Museum", lat: 50.842500, lang: 4.358333),
    HistoricalPlace(name: "Waterloo Battlefield", lat: 50.679722, lang: 4.403889),
    HistoricalPlace(name: "Cinquantenaire Arch", lat: 50.840556, lang: 4.391667),
    HistoricalPlace(name: "Notre-Dame de Tournai", lat: 50.605278, lang: 3.388056),
    HistoricalPlace(name: "Plantin-Moretus Museum", lat: 51.219444, lang: 4.401389),
    HistoricalPlace(name: "Menin Gate", lat: 50.852222, lang: 2.892222),
    HistoricalPlace(name: "Citadel of Namur", lat: 50.463889, lang: 4.860833),
    HistoricalPlace(name: "Boudewijn Seapark", lat: 51.208889, lang: 3.200556),
    HistoricalPlace(name: "Bruges Markt", lat: 51.208333, lang: 3.224722),

    // isviçre
    HistoricalPlace(name: "Swiss National Museum", lat: 47.379167, lang: 8.540278),
    HistoricalPlace(name: "Kunsthaus Zürich", lat: 47.370278, lang: 8.548333),
    HistoricalPlace(name: "Chillon Castle", lat: 46.414444, lang: 6.927222),
    HistoricalPlace(name: "Matterhorn", lat: 45.976389, lang: 7.658333),
    HistoricalPlace(name: "Jungfraujoch", lat: 46.547500, lang: 7.985278),
    HistoricalPlace(name: "Chapel Bridge Lucerne", lat: 47.051944, lang: 8.307222),
    HistoricalPlace(name: "Rhine Falls", lat: 47.677500, lang: 8.615556),
    HistoricalPlace(name: "St. Pierre Cathedral", lat: 46.200833, lang: 6.148611),
    HistoricalPlace(name: "Olympic Museum", lat: 46.508333, lang: 6.635556),
    HistoricalPlace(name: "Bern Old Town", lat: 46.947778, lang: 7.447778),
    HistoricalPlace(name: "Grossmünster", lat: 47.370278, lang: 8.544167),
    HistoricalPlace(name: "Zytglogge", lat: 46.948056, lang: 7.447778),
    HistoricalPlace(name: "Glacier Express Route", lat: 46.659722, lang: 8.628056),
    HistoricalPlace(name: "Abbey of St. Gallen", lat: 47.423333, lang: 9.376944),
    HistoricalPlace(name: "Einstein Museum", lat: 46.947778, lang: 7.451111),
    HistoricalPlace(name: "Lake Geneva", lat: 46.452222, lang: 6.531111),
    HistoricalPlace(name: "Aletsch Glacier", lat: 46.483333, lang: 8.016667),
    HistoricalPlace(name: "Château de Gruyères", lat: 46.583611, lang: 7.081389),
    HistoricalPlace(name: "Basel Minster", lat: 47.557222, lang: 7.592500),
    HistoricalPlace(name: "Museum Rietberg", lat: 47.357222, lang: 8.530833),
    HistoricalPlace(name: "Lugano Lake", lat: 46.005833, lang: 8.951667),
    HistoricalPlace(name: "Interlaken", lat: 46.686111, lang: 7.865556),
    HistoricalPlace(name: "Titlis Mountain", lat: 46.771944, lang: 8.435833),
    HistoricalPlace(name: "Bellinzona Castles", lat: 46.192500, lang: 9.026944),

    // avusturya
    HistoricalPlace(name: "Kunsthistorisches Museum", lat: 48.203611, lang: 16.361667),
    HistoricalPlace(name: "Schönbrunn Palace", lat: 48.184722, lang: 16.312222),
    HistoricalPlace(name: "Belvedere Palace", lat: 48.191389, lang: 16.380278),
    HistoricalPlace(name: "Hofburg Palace", lat: 48.206667, lang: 16.365278),
    HistoricalPlace(name: "St. Stephen's Cathedral", lat: 48.208611, lang: 16.373056),
    HistoricalPlace(name: "Salzburg Fortress", lat: 47.795278, lang: 13.047778),
    HistoricalPlace(name: "Mozart's Birthplace", lat: 47.800000, lang: 13.043889),
    HistoricalPlace(name: "Hallstatt", lat: 47.562222, lang: 13.649444),
    HistoricalPlace(name: "Innsbruck Golden Roof", lat: 47.268056, lang: 11.393611),
    HistoricalPlace(name: "Vienna State Opera", lat: 48.203056, lang: 16.368889),
    HistoricalPlace(name: "Melk Abbey", lat: 48.227222, lang: 15.334444),
    HistoricalPlace(name: "Wachau Valley", lat: 48.366667, lang: 15.416667),
    HistoricalPlace(name: "Prater Vienna", lat: 48.216667, lang: 16.396111),
    HistoricalPlace(name: "Mirabell Palace", lat: 47.805556, lang: 13.041667),
    HistoricalPlace(name: "Eisriesenwelt Ice Cave", lat: 47.506389, lang: 13.188889),
    HistoricalPlace(name: "Krimmler Waterfalls", lat: 47.220556, lang: 12.176389),
    HistoricalPlace(name: "Albertina Museum", lat: 48.204722, lang: 16.368333),
    HistoricalPlace(name: "Grossglockner Road", lat: 47.074444, lang: 12.834444),
    HistoricalPlace(name: "Swarovski Crystal Worlds", lat: 47.284167, lang: 11.582222),
    HistoricalPlace(name: "Leopold Museum", lat: 48.203611, lang: 16.359722),
    HistoricalPlace(name: "Graz Clock Tower", lat: 47.075556, lang: 15.438333),
    HistoricalPlace(name: "Klagenfurt Minimundus", lat: 46.613611, lang: 14.271389),
    HistoricalPlace(name: "Seefeld", lat: 47.331111, lang: 11.186111),
    HistoricalPlace(name: "Vienna Woods", lat: 48.166667, lang: 16.150000),
    HistoricalPlace(name: "Karlskirche", lat: 48.198056, lang: 16.371944),
    HistoricalPlace(name: "Kunsthaus Graz", lat: 47.070556, lang: 15.438889),

    // portekiz
    HistoricalPlace(name: "Jerónimos Monastery", lat: 38.697778, lang: -9.206111),
    HistoricalPlace(name: "Belém Tower", lat: 38.691667, lang: -9.215833),
    HistoricalPlace(name: "São Jorge Castle", lat: 38.713889, lang: -9.133333),
    HistoricalPlace(name: "Sintra National Palace", lat: 38.797778, lang: -9.390556),
    HistoricalPlace(name: "Pena Palace", lat: 38.787500, lang: -9.390556),
    HistoricalPlace(name: "Porto Cathedral", lat: 41.142778, lang: -8.611389),
    HistoricalPlace(name: "Clérigos Tower", lat: 41.145833, lang: -8.614167),
    HistoricalPlace(name: "Livraria Lello", lat: 41.146944, lang: -8.614722),
    HistoricalPlace(name: "National Museum Ancient Art", lat: 38.704722, lang: -9.161111),
    HistoricalPlace(name: "Gulbenkian Museum", lat: 38.737500, lang: -9.153611),
    HistoricalPlace(name: "Oceanário de Lisboa", lat: 38.763056, lang: -9.093611),
    HistoricalPlace(name: "Algarve Beaches", lat: 37.018889, lang: -7.930556),
    HistoricalPlace(name: "University of Coimbra", lat: 40.207500, lang: -8.426111),
    HistoricalPlace(name: "Douro Valley", lat: 41.166667, lang: -7.666667),
    HistoricalPlace(name: "Ponta da Piedade", lat: 37.080278, lang: -8.668889),
    HistoricalPlace(name: "Évora Roman Temple", lat: 38.573333, lang: -7.907222),
    HistoricalPlace(name: "Quinta da Regaleira", lat: 38.796111, lang: -9.395833),
    HistoricalPlace(name: "Cabo da Roca", lat: 38.780278, lang: -9.498889),
    HistoricalPlace(name: "Mosteiro da Batalha", lat: 39.659722, lang: -8.825556),
    HistoricalPlace(name: "Convento de Cristo", lat: 39.603889, lang: -8.419444),
    HistoricalPlace(name: "Ribeira District Porto", lat: 41.140833, lang: -8.613889),
    HistoricalPlace(name: "Serralves Museum", lat: 41.159444, lang: -8.659722),
    HistoricalPlace(name: "Lisbon Cathedral", lat: 38.709722, lang: -9.132778),
    HistoricalPlace(name: "Ponte 25 de Abril", lat: 38.692222, lang: -9.176667),
    HistoricalPlace(name: "Berlenga Island", lat: 39.413889, lang: -9.506111),

    // norveç
    HistoricalPlace(name: "Viking Ship Museum", lat: 59.904722, lang: 10.684167),
    HistoricalPlace(name: "Vigeland Sculpture Park", lat: 59.927222, lang: 10.700556),
    HistoricalPlace(name: "Akershus Fortress", lat: 59.907500, lang: 10.736389),
    HistoricalPlace(name: "Bryggen Bergen", lat: 60.397500, lang: 5.324444),
    HistoricalPlace(name: "Preikestolen", lat: 58.986667, lang: 6.190278),
    HistoricalPlace(name: "Geirangerfjord", lat: 62.101111, lang: 7.206667),
    HistoricalPlace(name: "Nidaros Cathedral", lat: 63.426944, lang: 10.396389),
    HistoricalPlace(name: "Fram Museum", lat: 59.902500, lang: 10.698889),
    HistoricalPlace(name: "Munch Museum", lat: 59.906389, lang: 10.755000),
    HistoricalPlace(name: "Northern Lights Tromsø", lat: 69.649444, lang: 18.955556),
    HistoricalPlace(name: "Atlantic Ocean Road", lat: 63.018056, lang: 7.355278),
    HistoricalPlace(name: "Lofoten Islands", lat: 68.213889, lang: 13.619444),
    HistoricalPlace(name: "Holmenkollen Ski Jump", lat: 59.963056, lang: 10.667222),
    HistoricalPlace(name: "Royal Palace Oslo", lat: 59.916944, lang: 10.728333),
    HistoricalPlace(name: "Urnes Stave Church", lat: 61.294722, lang: 7.326389),
    HistoricalPlace(name: "Trolltunga", lat: 60.124167, lang: 6.740833),
    HistoricalPlace(name: "Flåm Railway", lat: 60.863333, lang: 7.115833),
    HistoricalPlace(name: "Oslo Opera House", lat: 59.907500, lang: 10.753056),
    HistoricalPlace(name: "Sognefjord", lat: 61.090278, lang: 6.826389),

    // isveç
    HistoricalPlace(name: "Vasa Museum", lat: 59.327778, lang: 18.091389),
    HistoricalPlace(name: "ABBA Museum", lat: 59.325278, lang: 18.096944),
    HistoricalPlace(name: "Royal Palace Stockholm", lat: 59.326667, lang: 18.071389),
    HistoricalPlace(name: "Gamla Stan", lat: 59.325833, lang: 18.072222),
    HistoricalPlace(name: "Drottningholm Palace", lat: 59.321667, lang: 17.886667),
    HistoricalPlace(name: "Skansen Open-Air Museum", lat: 59.325833, lang: 18.103056),
    HistoricalPlace(name: "Ice Hotel", lat: 67.855556, lang: 20.618056),
    HistoricalPlace(name: "Stockholm City Hall", lat: 59.327500, lang: 18.054167),
    HistoricalPlace(name: "Göta Canal", lat: 58.410833, lang: 15.621389),
    HistoricalPlace(name: "Uppsala Cathedral", lat: 59.858056, lang: 17.632778),
    HistoricalPlace(name: "Liseberg", lat: 57.695556, lang: 11.991667),
    HistoricalPlace(name: "Visby Medieval Town", lat: 57.638056, lang: 18.295000),
    HistoricalPlace(name: "Turning Torso Malmö", lat: 55.613611, lang: 12.976111),
    HistoricalPlace(name: "Fotografiska Museum", lat: 59.317222, lang: 18.085278),
    HistoricalPlace(name: "Ales Stenar", lat: 55.382500, lang: 14.057222),
    HistoricalPlace(name: "Kalmar Castle", lat: 56.662222, lang: 16.361389),
    HistoricalPlace(name: "Öresund Bridge", lat: 55.576389, lang: 12.839722),
    HistoricalPlace(name: "Abisko National Park", lat: 68.354167, lang: 18.820556),
    HistoricalPlace(name: "Nordic Museum", lat: 59.328056, lang: 18.090833),
    HistoricalPlace(name: "Moderna Museet", lat: 59.325833, lang: 18.084722),
    HistoricalPlace(name: "Lund Cathedral", lat: 55.704722, lang: 13.193333),
    HistoricalPlace(name: "Archipelago Stockholm", lat: 59.350000, lang: 18.666667),
    HistoricalPlace(name: "Sigtuna", lat: 59.620833, lang: 17.722778),

    // danimarka
    HistoricalPlace(name: "Tivoli Gardens", lat: 55.673611, lang: 12.568056),
    HistoricalPlace(name: "Little Mermaid", lat: 55.692944, lang: 12.599278),
    HistoricalPlace(name: "Nyhavn", lat: 55.679722, lang: 12.591389),
    HistoricalPlace(name: "Kronborg Castle", lat: 56.038889, lang: 12.622222),
    HistoricalPlace(name: "Rosenborg Castle", lat: 55.685833, lang: 12.577500),
    HistoricalPlace(name: "Christiansborg Palace", lat: 55.676111, lang: 12.580278),
    HistoricalPlace(name: "National Museum Denmark", lat: 55.674444, lang: 12.574167),
    HistoricalPlace(name: "Amalienborg Palace", lat: 55.684167, lang: 12.593056),
    HistoricalPlace(name: "Frederiksborg Castle", lat: 55.934722, lang: 12.301389),
    HistoricalPlace(name: "Louisiana Museum", lat: 55.971389, lang: 12.547222),
    HistoricalPlace(name: "Legoland Billund", lat: 55.736389, lang: 9.126111),
    HistoricalPlace(name: "Roskilde Cathedral", lat: 55.641667, lang: 12.080278),
    HistoricalPlace(name: "Viking Ship Museum", lat: 55.654722, lang: 12.082778),
    HistoricalPlace(name: "Møns Klint", lat: 54.974167, lang: 12.558056),
    HistoricalPlace(name: "Round Tower", lat: 55.681389, lang: 12.575833),
    HistoricalPlace(name: "Ny Carlsberg Glyptotek", lat: 55.672778, lang: 12.572222),
    HistoricalPlace(name: "Den Gamle By", lat: 56.161667, lang: 10.195556),
    HistoricalPlace(name: "Egeskov Castle", lat: 55.191667, lang: 10.731667),
    HistoricalPlace(name: "Skagen", lat: 57.720833, lang: 10.583889),
    HistoricalPlace(name: "Ribe Viking Center", lat: 55.328056, lang: 8.762500),
    HistoricalPlace(name: "Christiania", lat: 55.673889, lang: 12.599444),

    // finlandiya 
    HistoricalPlace(name: "Suomenlinna Fortress", lat: 60.144722, lang: 24.988333),
    HistoricalPlace(name: "Helsinki Cathedral", lat: 60.170278, lang: 24.952222),
    HistoricalPlace(name: "Ateneum Art Museum", lat: 60.170000, lang: 24.943889),
    HistoricalPlace(name: "Temppeliaukio Church", lat: 60.172778, lang: 24.925278),
    HistoricalPlace(name: "Senate Square", lat: 60.169722, lang: 24.951667),
    HistoricalPlace(name: "Santa Claus Village", lat: 66.543611, lang: 25.847222),
    HistoricalPlace(name: "Olavinlinna Castle", lat: 61.867778, lang: 28.900000),
    HistoricalPlace(name: "Turku Castle", lat: 60.435556, lang: 22.228611),
    HistoricalPlace(name: "Kiasma Museum", lat: 60.171667, lang: 24.936389),
    HistoricalPlace(name: "Seurasaari Open-Air", lat: 60.182500, lang: 24.884444),
    HistoricalPlace(name: "Rovaniemi Arctic Circle", lat: 66.543889, lang: 25.845278),
    HistoricalPlace(name: "Porvoo Old Town", lat: 60.395278, lang: 25.665000),
    HistoricalPlace(name: "Rauma Old Town", lat: 61.128333, lang: 21.509444),
    HistoricalPlace(name: "Sibelius Monument", lat: 60.182222, lang: 24.913056),
    HistoricalPlace(name: "Linnanmäki", lat: 60.188889, lang: 24.940556),
    HistoricalPlace(name: "Turku Cathedral", lat: 60.453889, lang: 22.279167),
    HistoricalPlace(name: "Levi Ski Resort", lat: 67.805556, lang: 24.808889),
    HistoricalPlace(name: "Koli National Park", lat: 63.093889, lang: 29.808889),

    // polonya
    HistoricalPlace(name: "Auschwitz-Birkenau", lat: 50.026944, lang: 19.203889),
    HistoricalPlace(name: "Wawel Castle", lat: 50.054167, lang: 19.935278),
    HistoricalPlace(name: "Main Market Square Kraków", lat: 50.061667, lang: 19.937222),
    HistoricalPlace(name: "Wieliczka Salt Mine", lat: 49.983611, lang: 20.054722),
    HistoricalPlace(name: "Warsaw Old Town", lat: 52.249167, lang: 21.012222),
    HistoricalPlace(name: "Royal Castle Warsaw", lat: 52.248056, lang: 21.014722),
    HistoricalPlace(name: "Malbork Castle", lat: 54.040000, lang: 19.029444),
    HistoricalPlace(name: "St. Mary's Basilica", lat: 50.061667, lang: 19.939444),
    HistoricalPlace(name: "Schindler's Factory", lat: 50.047778, lang: 19.960833),
    HistoricalPlace(name: "Palace of Culture", lat: 52.231667, lang: 21.006111),
    HistoricalPlace(name: "Łazienki Park", lat: 52.215278, lang: 21.035556),
    HistoricalPlace(name: "Gdańsk Old Town", lat: 54.349444, lang: 18.653611),
    HistoricalPlace(name: "Wrocław Market Square", lat: 51.109722, lang: 17.031667),
    HistoricalPlace(name: "Toruń Old Town", lat: 53.010278, lang: 18.605556),
    HistoricalPlace(name: "Zakopane Tatra Mountains", lat: 49.299167, lang: 19.950000),
    HistoricalPlace(name: "Białowieża Forest", lat: 52.700000, lang: 23.850000),
    HistoricalPlace(name: "Wolf's Lair", lat: 54.079722, lang: 21.493889),
    HistoricalPlace(name: "Kazimierz Jewish Quarter", lat: 50.051944, lang: 19.946667),
    HistoricalPlace(name: "National Museum Warsaw", lat: 52.231389, lang: 21.024444),
    HistoricalPlace(name: "Poznań Old Market", lat: 52.408333, lang: 16.934167),
    HistoricalPlace(name: "Książ Castle", lat: 50.843056, lang: 16.292500),
    HistoricalPlace(name: "Masurian Lakes", lat: 53.900000, lang: 21.583333),
    HistoricalPlace(name: "Słowiński National Park", lat: 54.733333, lang: 17.300000),
    HistoricalPlace(name: "Ojców National Park", lat: 50.212500, lang: 19.829167),
    HistoricalPlace(name: "POLIN Museum", lat: 52.249722, lang: 20.994167),
    HistoricalPlace(name: "Częstochowa Monastery", lat: 50.808333, lang: 19.096111),
    HistoricalPlace(name: "Lublin Castle", lat: 51.248611, lang: 22.571111),

    // çek cumhuriyeti
    HistoricalPlace(name: "Prague Castle", lat: 50.090278, lang: 14.400000),
    HistoricalPlace(name: "Charles Bridge", lat: 50.086528, lang: 14.411389),
    HistoricalPlace(name: "Old Town Square Prague", lat: 50.087500, lang: 14.421111),
    HistoricalPlace(name: "Astronomical Clock", lat: 50.087083, lang: 14.420556),
    HistoricalPlace(name: "St. Vitus Cathedral", lat: 50.090833, lang: 14.400278),
    HistoricalPlace(name: "Český Krumlov", lat: 48.810833, lang: 14.315278),
    HistoricalPlace(name: "Karlštejn Castle", lat: 49.938889, lang: 14.188056),
    HistoricalPlace(name: "Kutná Hora", lat: 49.948611, lang: 15.268056),
    HistoricalPlace(name: "Lednice-Valtice", lat: 48.799444, lang: 16.802778),
    HistoricalPlace(name: "Brno Cathedral", lat: 49.191111, lang: 16.607222),
    HistoricalPlace(name: "Vyšehrad", lat: 50.064444, lang: 14.418056),
    HistoricalPlace(name: "Petřín Tower", lat: 50.083611, lang: 14.398056),
    HistoricalPlace(name: "National Museum Prague", lat: 50.079722, lang: 14.432500),
    HistoricalPlace(name: "Jewish Quarter Prague", lat: 50.090000, lang: 14.418333),
    HistoricalPlace(name: "Špilberk Castle", lat: 49.194167, lang: 16.599444),
    HistoricalPlace(name: "Hluboká Castle", lat: 49.052222, lang: 14.443056),
    HistoricalPlace(name: "Karlovy Vary", lat: 50.230278, lang: 12.871111),
    HistoricalPlace(name: "Moravian Karst", lat: 49.376389, lang: 16.731667),
    HistoricalPlace(name: "Telč", lat: 49.184167, lang: 15.453333),
    HistoricalPlace(name: "Olomouc Holy Trinity", lat: 49.593611, lang: 17.250833),
    HistoricalPlace(name: "Litomyšl Castle", lat: 49.874167, lang: 16.312778),
    HistoricalPlace(name: "Konopiště Castle", lat: 49.779722, lang: 14.657778),
    HistoricalPlace(name: "Třeboň", lat: 49.003333, lang: 14.770556),

    // macaristan
    HistoricalPlace(name: "Hungarian Parliament", lat: 47.507222, lang: 19.045556),
    HistoricalPlace(name: "Buda Castle", lat: 47.496389, lang: 19.039444),
    HistoricalPlace(name: "Fisherman's Bastion", lat: 47.502222, lang: 19.034722),
    HistoricalPlace(name: "St. Stephen's Basilica", lat: 47.501111, lang: 19.053889),
    HistoricalPlace(name: "Chain Bridge", lat: 47.498889, lang: 19.043611),
    HistoricalPlace(name: "Heroes' Square", lat: 47.514722, lang: 19.077500),
    HistoricalPlace(name: "Széchenyi Thermal Bath", lat: 47.519444, lang: 19.081667),
    HistoricalPlace(name: "Great Synagogue", lat: 47.496111, lang: 19.061944),
    HistoricalPlace(name: "Lake Balaton", lat: 46.906111, lang: 17.893333),
    HistoricalPlace(name: "Eger Castle", lat: 47.903333, lang: 20.377222),
    HistoricalPlace(name: "Aggtelek Cave", lat: 48.468333, lang: 20.493889),
    HistoricalPlace(name: "Hortobágy National Park", lat: 47.583333, lang: 21.133333),
    HistoricalPlace(name: "Matthias Church", lat: 47.502222, lang: 19.034444),
    HistoricalPlace(name: "Danube Bend", lat: 47.793333, lang: 18.920000),
    HistoricalPlace(name: "Hollókő Village", lat: 47.996667, lang: 19.591667),
    HistoricalPlace(name: "Pécs Cathedral", lat: 46.078056, lang: 18.229167),
    HistoricalPlace(name: "Visegrád Castle", lat: 47.786944, lang: 18.970278),
    HistoricalPlace(name: "Gödöllő Palace", lat: 47.596111, lang: 19.368889),
    HistoricalPlace(name: "Sopron Old Town", lat: 47.685000, lang: 16.591389),
    HistoricalPlace(name: "Pannonhalma Abbey", lat: 47.550556, lang: 17.758333),

    // romanya
    HistoricalPlace(name: "Bran Castle", lat: 45.515000, lang: 25.367222),
    HistoricalPlace(name: "Palace of Parliament", lat: 44.427500, lang: 26.087222),
    HistoricalPlace(name: "Peleș Castle", lat: 45.360000, lang: 25.542500),
    HistoricalPlace(name: "Village Museum Bucharest", lat: 44.471944, lang: 26.076944),
    HistoricalPlace(name: "Transfăgărășan Road", lat: 45.601944, lang: 24.618611),
    HistoricalPlace(name: "Painted Monasteries", lat: 47.622222, lang: 25.915000),
    HistoricalPlace(name: "Sighișoara", lat: 46.220278, lang: 24.792500),
    HistoricalPlace(name: "Corvin Castle", lat: 45.747778, lang: 22.889167),
    HistoricalPlace(name: "Brașov Old Town", lat: 45.642500, lang: 25.588611),
    HistoricalPlace(name: "Danube Delta", lat: 45.166667, lang: 29.500000),
    HistoricalPlace(name: "Merry Cemetery", lat: 47.971111, lang: 23.691667),
    HistoricalPlace(name: "Alba Carolina Fortress", lat: 46.067222, lang: 23.571111),
    HistoricalPlace(name: "Salina Turda", lat: 46.588056, lang: 23.784722),
    HistoricalPlace(name: "Black Church Brașov", lat: 45.642222, lang: 25.589167),
    HistoricalPlace(name: "Fortified Churches", lat: 46.008333, lang: 24.500000),
    HistoricalPlace(name: "Bâlea Lake", lat: 45.606389, lang: 24.618889),
    HistoricalPlace(name: "Turda Gorge", lat: 46.570833, lang: 23.712222),
    HistoricalPlace(name: "Curtea de Argeș", lat: 45.136389, lang: 24.674444),
    HistoricalPlace(name: "Horezu Monastery", lat: 45.154444, lang: 24.014722),

    // hırvatistan
    HistoricalPlace(name: "Diocletian's Palace", lat: 43.508056, lang: 16.440278),
    HistoricalPlace(name: "Dubrovnik Old Town", lat: 42.641389, lang: 18.108333),
    HistoricalPlace(name: "Plitvice Lakes", lat: 44.880000, lang: 15.616667),
    HistoricalPlace(name: "Hvar Island", lat: 43.172500, lang: 16.441667),
    HistoricalPlace(name: "Euphrasian Basilica", lat: 45.227500, lang: 13.592500),
    HistoricalPlace(name: "Zagreb Cathedral", lat: 45.814444, lang: 15.979167),
    HistoricalPlace(name: "Amphitheatre Pula", lat: 44.873889, lang: 13.850000),
    HistoricalPlace(name: "Trogir Old Town", lat: 43.515278, lang: 16.251389),
    HistoricalPlace(name: "Šibenik St. James", lat: 43.735556, lang: 15.894722),
    HistoricalPlace(name: "Krka National Park", lat: 43.807222, lang: 15.970556),
    HistoricalPlace(name: "Lokrum Island", lat: 42.625833, lang: 18.120556),
    HistoricalPlace(name: "Zlatni Rat Beach", lat: 43.256389, lang: 16.635000),
    HistoricalPlace(name: "Mljet National Park", lat: 42.772222, lang: 17.377778),
    HistoricalPlace(name: "Rovinj Old Town", lat: 45.080556, lang: 13.639444),
    HistoricalPlace(name: "Zadar Sea Organ", lat: 44.119444, lang: 15.228056),
    HistoricalPlace(name: "Motovun", lat: 45.336667, lang: 13.828611),
    HistoricalPlace(name: "Kornati Islands", lat: 43.816667, lang: 15.316667),
    HistoricalPlace(name: "Trakošćan Castle", lat: 46.240000, lang: 16.002778),
    HistoricalPlace(name: "Elafiti Islands", lat: 42.715000, lang: 17.941667),
    HistoricalPlace(name: "Paklenica National Park", lat: 44.381667, lang: 15.467778),
    HistoricalPlace(name: "Varaždin", lat: 46.305556, lang: 16.336944),
    HistoricalPlace(name: "Brijuni Islands", lat: 44.915000, lang: 13.762778),

    // irlanda
    HistoricalPlace(name: "Trinity College Library", lat: 53.343889, lang: -6.254444),
    HistoricalPlace(name: "Cliffs of Moher", lat: 52.971944, lang: -9.426389),
    HistoricalPlace(name: "Dublin Castle", lat: 53.342778, lang: -6.267500),
    HistoricalPlace(name: "Guinness Storehouse", lat: 53.341944, lang: -6.286667),
    HistoricalPlace(name: "Blarney Castle", lat: 51.929444, lang: -8.570556),
    HistoricalPlace(name: "Ring of Kerry", lat: 51.950000, lang: -9.700000),
    HistoricalPlace(name: "Giant's Causeway", lat: 55.240833, lang: -6.511667),
    HistoricalPlace(name: "Kilmainham Gaol", lat: 53.342222, lang: -6.310278),
    HistoricalPlace(name: "Newgrange", lat: 53.694722, lang: -6.475278),
    HistoricalPlace(name: "Rock of Cashel", lat: 52.520278, lang: -7.890556),
    HistoricalPlace(name: "Killarney National Park", lat: 52.016667, lang: -9.566667),
    HistoricalPlace(name: "Galway City", lat: 53.270833, lang: -9.056667),
    HistoricalPlace(name: "Connemara", lat: 53.533333, lang: -9.750000),
    HistoricalPlace(name: "Dingle Peninsula", lat: 52.140000, lang: -10.266667),
    HistoricalPlace(name: "St. Patrick's Cathedral", lat: 53.339444, lang: -6.271389),
    HistoricalPlace(name: "Phoenix Park", lat: 53.355833, lang: -6.328889),
    HistoricalPlace(name: "Aran Islands", lat: 53.125000, lang: -9.766667),
    HistoricalPlace(name: "Powerscourt Estate", lat: 53.184444, lang: -6.186667),
    HistoricalPlace(name: "Kylemore Abbey", lat: 53.560556, lang: -9.888333),
    HistoricalPlace(name: "Skellig Michael", lat: 51.770833, lang: -10.540278),
    HistoricalPlace(name: "Cobh Heritage Centre", lat: 51.850833, lang: -8.294167),

    // iskoçya
    HistoricalPlace(name: "Edinburgh Castle", lat: 55.948611, lang: -3.199722),
    HistoricalPlace(name: "Loch Ness", lat: 57.322778, lang: -4.424444),
    HistoricalPlace(name: "Stirling Castle", lat: 56.123889, lang: -3.949167),
    HistoricalPlace(name: "Isle of Skye", lat: 57.410000, lang: -6.193333),
    HistoricalPlace(name: "Holyrood Palace", lat: 55.952778, lang: -3.171944),
    HistoricalPlace(name: "Glasgow Cathedral", lat: 55.862778, lang: -4.233611),
    HistoricalPlace(name: "Royal Mile", lat: 55.950278, lang: -3.188889),
    HistoricalPlace(name: "Ben Nevis", lat: 56.796944, lang: -5.003611),
    HistoricalPlace(name: "Eilean Donan Castle", lat: 57.273611, lang: -5.516389),
    HistoricalPlace(name: "Culloden Battlefield", lat: 57.478889, lang: -4.090278),
    HistoricalPlace(name: "St. Andrews", lat: 56.340278, lang: -2.796944),
    HistoricalPlace(name: "Kelvingrove Museum", lat: 55.868333, lang: -4.275833),
    HistoricalPlace(name: "Glencoe", lat: 56.673333, lang: -5.106111),
    HistoricalPlace(name: "Rosslyn Chapel", lat: 55.855000, lang: -3.160556),
    HistoricalPlace(name: "Urquhart Castle", lat: 57.322222, lang: -4.443333),
    HistoricalPlace(name: "Dunnottar Castle", lat: 56.946111, lang: -2.196944), 
    HistoricalPlace(name: "Arthur's Seat", lat: 55.944444, lang: -3.161667),
  ];

  static void showPlaceOptions (BuildContext context, HistoricalPlace place) {
    showModalBottomSheet(
      context: context, 
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(place.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 16,),
            ListTile(
              leading: Icon(Icons.map, color: Colors.blue,),
              title: Platform.isAndroid ? Text("Google Maps'te Aç") : Text("Maps' te Aç"),
              onTap: () {
                Navigator.of(context).pop();
                openInGoogleMaps(place.lat, place.lang, place.name);
              },
            )
          ],
        ),
      )
    );
  }

  static Future<void> openInGoogleMaps (double lat, double lang, String name) async {
  
    final androidUrl = Uri.parse("geo:$lat,$lang?q=$lat,$lang($name)");
    final iosUrl = Uri.parse("https://maps.apple.com/?q=$name&ll=$lat,$lang");
                              

    if (Platform.isIOS) {
      if (await canLaunchUrl(iosUrl)) {
        await launchUrl(iosUrl, mode: LaunchMode.externalApplication);
      }
    }
    else {
      if (await canLaunchUrl(androidUrl)) {
        await launchUrl(androidUrl, mode: LaunchMode.externalApplication);
      }
    }

    
  }


  static Future<void> openAllInGoogleMaps () async {
    final center = place.first;
    String waypoint = place.take(2).map((p) => "${p.lat},${p.lang}").join("|");
    final url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${center.lat},${center.lang}&waypoints=$waypoint");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }


}




class AudioService {
  
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;
  String _currentText = "";

  double _progress = 0.0;
  bool get isPlaying => _isPlaying;

  double get progress => _progress;
  double _pausedAt = 0.0;

  Function()? onStatusChanged;


  void setTextfromList (List<ContentModel> contentList) {

    StringBuffer combinedText = StringBuffer();

    for (var item in contentList) {
      combinedText.write(item.title);
      combinedText.write(".");
      combinedText.write(item.content);
      combinedText.write(".");

    }

    _currentText = combinedText.toString();

  }


  Future<void> initialize () async {

    String languageCode = await getDeviceLanguageCode();
    // TTS motorunun ayarları:
    await _tts.setLanguage(languageCode);    
    await _tts.setSpeechRate(0.5);      // Konuşma hızı (0.5 = yavaş)
    await _tts.setVolume(1.0);          // Ses seviyesi (1.0 = maksimum)
    await _tts.setPitch(1.0);           // Ses tonu (1.0 = normal)

    _tts.setCompletionHandler(() {
      //print("Ses okuma bitti!");
      _isPlaying = false; 
      _progress = 0.0;
      _pausedAt = 0.0;
      stop();
    });

    if (onStatusChanged != null) {
      onStatusChanged!();
    }

    _tts.setProgressHandler((text, start, end, word) {
      if (_currentText.isNotEmpty) {
        // Eğer pause'dan sonra devam ediyorsak, pausedAt'i ekle
        double baseProgress = end / _currentText.length;
        
        if (_pausedAt > 0) {
          _progress = _pausedAt + (baseProgress * (1 - _pausedAt));
        } else {
          _progress = baseProgress;
        }
        
        if (onStatusChanged != null) {
          onStatusChanged!();
        }
      }
    });

  }

  Future<String> getDeviceLanguageCode() async {
    final Locale deviceLocale = await PlatformDispatcher.instance.locales.first;
    return deviceLocale.languageCode;
  } 


  // Metni okumaya başla VEYA devam et
  Future<void> play () async {

    if (_currentText.isEmpty) {
      //print("Okunacak metin yok!");
      return;
    }

    if (_pausedAt > 0) {
      int startIndex = (_currentText.length * _pausedAt).toInt();
      String remainingText = _currentText.substring(startIndex);
      
      await _tts.speak(remainingText);
      _isPlaying = true;
      //print("Kaldığı yerden devam ediyor: ${_pausedAt * 100}%");
    } else {
      // Baştan başla
      await _tts.speak(_currentText);
      _isPlaying = true;
      _progress = 0.0;
      //print("Ses okuma başladı!");
    }
    
    if (onStatusChanged != null) {
      onStatusChanged!();
    }

  }   


  // Sesi duraklat (pause)
  Future<void> pause () async {

    await _tts.stop();
    _pausedAt = _progress;
    _isPlaying = false;

    if (onStatusChanged != null) {
      onStatusChanged!();
    }

  }     


  // Sesi tamamen durdur ve başa sar
  Future<void> stop () async {

    await _tts.stop();
    _isPlaying = false;
    _progress = 0.0;
    _pausedAt = 0.0; // Tamamen sıfırla
    //print("Ses tamamen durduruldu!");

    if (onStatusChanged != null) {
      onStatusChanged!();
    }

  }


  Future<void> seekTo (double percentage) async {

    int startIndex = (_currentText.length * percentage).toInt();
    startIndex = startIndex.clamp(0, _currentText.length - 1);

    String remainingText = _currentText.substring(startIndex);

    await _tts.stop();
    _progress = percentage;
    _pausedAt = percentage;

    await Future.delayed(Duration(milliseconds: 100));
    await _tts.speak(remainingText);
    _isPlaying = true;

    if (onStatusChanged != null) {
      onStatusChanged!();
    }

  }


  void dispose () {
    _tts.stop();
  }


}




class OnboardingStep {

  final String title;
  final String description;
  final String imageAssets;

  OnboardingStep({required this.title, required this.description, required this.imageAssets});


  
}
