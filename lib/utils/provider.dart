import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProviderForDB {
  static Database db;

  Future init(bool isCreate) async {
    String dataBasesPath = await getDatabasesPath();
    String path = join(dataBasesPath, 'ShowTime.db');
    print("DatabasePath:$path");
    try {
//      db = await openDatabase(path);
      db = await openDatabase(path, version: 4,
          onCreate: (Database db, int version) async {
        print('db created version is $version');
        await db.execute(
            'CREATE TABLE channel (id INTEGER PRIMARY KEY, name TEXT, typeId TEXT)');
      }, onOpen: (Database db) {
        print('new db opened');
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async{
            if(newVersion==4){
              await db.execute(
                  'CREATE TABLE book (id INTEGER PRIMARY KEY, bookId TEXT, cover TEXT,author TEXT,majorCate TEXT,title TEXT,shortIntro TEXT,contentType TEXT,allowMonthly INTEGER ,hasCp INTEGER ,latelyFollower INTEGER ,retentionRatio REAL ,updated TEXT,chaptersCount INTEGER ,lastChapter TEXT)'
              );
            }
            print('db oldVersion:$oldVersion');
            print('db newVersion:$newVersion');
          });
    } catch (e) {
      print("DatabaseError:$e");
    }

//    bool tableIsAllRight = await this.checkTableIsAllRight();
//
//    if(!tableIsAllRight){
//      // 关闭上面打开的db，否则无法执行open
//      db.close();
//
//      db = await openDatabase(path,version: 1,onCreate: (Database db,int version)async{
//        print('db created version is $version');
//        await db.execute('CREATE TABLE channel (id INTEGER PRIMARY KEY, name TEXT, typeId TEXT)');
//      },onOpen: (Database db){
//        print('new db opened');
//      },onUpgrade: (Database db, int oldVersion, int newVersion){
//        print('db oldVersion:$oldVersion');
//        print('db newVersion:$newVersion');
//      });
//    }else {
//      print("Opening existing database");
//    }
  }

  //检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsAllRight() async {
    List<String> expectTables = ['channel'];

    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  Future getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }
}
