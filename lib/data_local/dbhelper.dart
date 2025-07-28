import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelp {
  DBhelp._();

  static final DBhelp getinstance = DBhelp._();

  static final String TABLE_NAME = "NoteX";
  static final String COLUMN_SNO = "S_no";
  static final String COLUMN_TITLE = "Title";
  static final String COLUMN_DESC = "Description";

  //db open if exists and if not then create
  Database? myDB;
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String DBpath = join(appdir.path, "notesDB.db");
    return await openDatabase(
      DBpath,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_NAME($COLUMN_SNO integer primary key autoincrement , $COLUMN_TITLE text ,$COLUMN_DESC text)",
        );
      },
      version: 1,
    );
  }

  // all queries

  Future<bool> addnote({required String mtitle, required String mdesc}) async {
    var db = await getDB();
    int rowseffected = await db.insert(TABLE_NAME, {
      COLUMN_TITLE: mtitle,
      COLUMN_DESC: mdesc,
    });
    return rowseffected > 0;
  }

  Future<bool> updatenote({
    required int msno,
    required String mtitle,
    required String mdesc,
  }) async {
    var db = await getDB();
    int rowseffected = await db.update(TABLE_NAME, {
      COLUMN_TITLE: mtitle,
      COLUMN_DESC: mdesc,
    }, where: '$COLUMN_SNO =?' ,whereArgs: [msno]);

    return rowseffected > 0;
  }

  Future<bool> deletenote({required int msno}) async {
    var db = await getDB();
    int rowseffected = await db.delete(TABLE_NAME, where: "$COLUMN_SNO=$msno");
    return rowseffected > 0;
  }

  Future<List<Map<String, dynamic>>> getallnotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NAME);
    return mData;
  }
}
