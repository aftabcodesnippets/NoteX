import 'package:flutter/widgets.dart';

class ThemeProvider extends ChangeNotifier{
 bool _themeValue = false;

 bool gettheme ()=> _themeValue;
 void updatetheme({required bool value}){
                   _themeValue=value;
                   notifyListeners();

 }

}