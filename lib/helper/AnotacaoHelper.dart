import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper.internal();
  late Database _db;

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
        "CREATE TABLE tbanotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, dtanotacao DATETIME)";
    await db.execute(sql);
  }

  Future<Database> initializeDb() async{
    final pathDataBase = await getDatabasesPath();
    final dataBase = join(pathDataBase, "minhas_notas.db");
    var db = await openDatabase(dataBase, version: 1, onCreate: _onCreate);
    return db;
  }


}