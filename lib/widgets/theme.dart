
import 'package:flutter/material.dart';


class colors {

  final Color scafoldColor_1 = Color.fromRGBO(240, 234, 222, 1);
  final Color scafoldColor_2 = Color.fromRGBO(245, 236, 213, 1);
  final Color scafoldColor_3 = Color.fromRGBO(229, 225, 213, 1);

  final Color cardColor_1 = Color.fromRGBO(251, 239, 213, 1);
  final Color cardColor_2 = Color.fromRGBO(138, 93, 67, 1);
  final Color cardColor_3 = Color.fromRGBO(176, 151, 129, 1);
  final Color cardColor_4 = Color.fromRGBO(116, 88, 77, 1);
  final Color cardColor_5 = Color.fromRGBO(198, 184, 158, 1);

}




final ThemeData lightTheme = ThemeData(

  scaffoldBackgroundColor: Color.fromRGBO(237, 234, 227, 1), /*Colors.grey.shade200,*/ //!

  textTheme: TextTheme(

    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),

    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 20
    ),

    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.bold
    ),

    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 22
    ),

    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 15
    ),

    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 19
    ),

    labelMedium: TextStyle(
      color: Colors.black.withAlpha(50),
      fontSize: 24
    ) 

  ),


  switchTheme: SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.black),
    trackColor: WidgetStatePropertyAll(Colors.transparent)
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedIconTheme: IconThemeData(
      color: Colors.black
    ),
    selectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
    selectedLabelStyle: TextStyle(
      color: Colors.white
    )
  ),

  //! BOTTOM BUTON THEME
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,

    primaryFixed: Colors.white
  ),


  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(229, 225, 213, 1),
    iconTheme: IconThemeData(
      color: Colors.grey
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.black
    ),
  ),
  
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    iconSize: 34
  ),

  iconTheme: IconThemeData(
    color: Colors.black
  ),

  cardColor: Color.fromRGBO(255, 255, 255, 1), /*Colors.white,*/ //!

  shadowColor: Colors.grey.shade400,

  canvasColor: Colors.black,

  
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white
  ),

  

  dividerColor: Colors.grey.shade500
  


);






final ThemeData darkTheme = ThemeData(
  
  scaffoldBackgroundColor: Colors.black,

  textTheme: TextTheme(

    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),

    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20
    ),

    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.bold
    ),

    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 22
    ),

    labelSmall: TextStyle(
      color: Colors.white,
      fontSize: 15
    ),

    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 19
    ),

    labelMedium: TextStyle(
      color: Colors.white.withAlpha(80),
      fontSize: 24
    ) 

  ),
  

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.black),
    trackColor: WidgetStatePropertyAll(Colors.white)
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white.withAlpha(50),
    selectedItemColor: Colors.grey.shade200,
    unselectedIconTheme: IconThemeData(
      color: Colors.white
    ),
    selectedIconTheme: IconThemeData(
      color: Colors.black,
    ),
    
  ),

  //! BOTTOM BUTON THEME
  colorScheme: ColorScheme.dark(
    primary: Colors.white.withAlpha(50),
    secondary: Colors.white,

    primaryFixed: Colors.black
  ),


  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.grey
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.white
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade700,
    iconSize: 34
  ),

  iconTheme: IconThemeData(
    color: Colors.white,
  ),

  cardColor: Colors.grey.shade800,

  shadowColor: Colors.white38,

  canvasColor: Colors.white,

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.black
  ),

  dividerColor: Colors.grey.shade500

);