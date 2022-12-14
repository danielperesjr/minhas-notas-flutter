import 'package:minhas_notas/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{
  static final String nmTable = "tbanotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){
  }

  get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initializeDb();
      return _db;
    }
  }

  void _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nmTable ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "dtanotacao DATETIME"
        ")";
    await db.execute(sql);
  }

  Future<Database> initializeDb() async{
    final pathDataBase = await getDatabasesPath();
    final dataBase = join(pathDataBase, "minhas_notas.db");
    var db = await openDatabase(dataBase, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveNote(Anotacao anotacao) async {
    var dataBase = await db;
    int result = await dataBase.insert(nmTable, anotacao.toMap());
    return result;
  }

  Future<int> updateNote(Anotacao anotacao) async {
    var dataBase = await db;
    int result = await dataBase.update(
      nmTable,
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
    );
    return result;
  }

  Future<List> recoverNote() async {
    var dataBase = await db;
    String sql = "SELECT * FROM $nmTable ORDER BY dtanotacao DESC";
    List notes = await dataBase.rawQuery(sql);
    return notes;
  }

  Future<int> deleteNote(int id) async {
    var dataBase = await db;
    int result = await dataBase.delete(
      nmTable,
      where: "id = ?",
      whereArgs: [id]
    );
    return result;
  }

}