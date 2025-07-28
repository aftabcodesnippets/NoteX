import 'package:flutter/widgets.dart';
import 'package:notex/data_local/dbhelper.dart';

class DbProvider extends ChangeNotifier{
 DBhelp dbhelper ;
  
  DbProvider({required this.dbhelper});

  List<Map<String, dynamic>> _mDAta=[];

  void addnote(String title , String desc)async{
    bool check = await dbhelper.addnote(mtitle: title, mdesc: desc);
    if(check){
      _mDAta=await dbhelper.getallnotes();
      notifyListeners();
    }


  }

  void updatenote(String title , String desc , int sno)async{
  bool check = await dbhelper.updatenote(msno: sno, mtitle: title, mdesc: desc);
  if(check){
    _mDAta=await dbhelper.getallnotes();
    notifyListeners();
  }

  }

  void deletenote(int sno)async{
    bool check = await dbhelper.deletenote(msno: sno);
    if(check){
      _mDAta =await dbhelper.getallnotes();
      notifyListeners();
    }
  }
    
    List<Map<String , dynamic>> getAllnotes()=>_mDAta;

    void getinitialnotes()async{
    _mDAta = await dbhelper.getallnotes();
    notifyListeners();
      

    }



}