import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  //Nome del database
  static const _databaseName = 'todo_database.db';
  //Versione del database (utile per gestire aggiornamenti futuri dello schema)
  static const _databaseVersion = 1;

  //Implementazione del pattern Singleton per garantire una sola istanza della classe
  static final AppDatabase instance = AppDatabase._internal();
  //Riferimento al database, inizialmente nullo
  static Database? _database;
  AppDatabase();
  //Costruttore privato per il Singleton
  AppDatabase._internal();

  //Getter per ottenere l'istanza del database
  Future<Database> get database async {
    //Se il database è già stato inizializzato, restituiscilo direttamente
    if (_database != null) return _database!;
    //Altrimenti, inizializza il database
    _database = await _initDatabase();
    return _database!;
  }

  //Metodo per inizializzare il database
  Future<Database> _initDatabase() async {
    //Ottiene il percorso della directory dove verrà salvato il database
    final dbPath = await getDatabasesPath();
    //Crea il percorso completo del database
    final path = join(dbPath, _databaseName);

    //Apri il database (o crealo se non esiste)
    return await openDatabase(
      path,
      version: _databaseVersion,
      //Specifica la funzione da chiamare quando il database viene creato per la prima volta
      onCreate: _onCreate,
    );
  }

  //Metodo chiamato quando il database viene creato per la prima volta
  Future<void> _onCreate(Database db, int version) async {
    String sql = '''CREATE TABLE todos (id INTEGER PRIMARY KEY AUTOINCREMENT, 
                    title TEXT NOT NULL,
                    description TEXT NOT NULL,
                    isCompleted INTEGER NOT NULL,
                    dateTodo DATETIME NOT NULL,
                    categoryId INTEGER NOT NULL,
                    FOREIGN KEY (categoryId) REFERENCES category(id)
    );
    
    CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
  );
  ''';
    //Esegui una query SQL per creare la tabella 'todos'
    await db.execute(sql);
  }
}
