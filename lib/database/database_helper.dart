import 'package:sqflite/sqflite.dart';
// Importa il pacchetto path per gestire i percorsi dei file
import 'package:path/path.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';

// Classe helper per la gestione del database
class DatabaseHelper {
  // Implementa il pattern singleton per garantire una sola istanza della classe
  static final DatabaseHelper instance = DatabaseHelper._init();
  // Variabile che conterrà l'istanza del database
  static Database? _database;

  // Costruttore privato per il singleton
  DatabaseHelper._init();

  // Getter asincrono per ottenere l'istanza del database
  Future<Database> get database async {
    // Se il database è già stato inizializzato, lo restituisce
    if (_database != null) return _database!;
    // Altrimenti, inizializza il database chiamando il metodo _initDB
    _database = await _initDB('todos.db');
    return _database!;
  }

  // Funzione per inizializzare il database
  Future<Database> _initDB(String filePath) async {
    // Ottiene il percorso della directory dove vengono salvati i database
    final dbPath = await getDatabasesPath();
    // Crea il percorso completo del file del database
    final path = join(dbPath, filePath);
    // Apre il database; se non esiste, lo crea e chiama il metodo _createDB per inizializzarlo
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    ); // Aggiunto per gestire aggiornamenti);
  }

  Future _createDB(Database db, int version) async {
    // Creazione della tabella "category"
    await db.execute('''
    CREATE TABLE category (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      color TEXT NOT NULL
    )
  ''');

    // Creazione della tabella "todos"
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      isCompleted INTEGER NOT NULL,
      dateTodo DATETIME NOT NULL,
      categoryId INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES category(id) ON DELETE CASCADE
    )
  ''');
  }

  // Se cambi lo schema, aggiorna la tabella qui
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS category');
      await db.execute('DROP TABLE IF EXISTS todos');
      await _createDB(db, newVersion);
    }
  }

  //TODO

  // Funzione per inserire un nuovo Todo nel database
  Future<int> insertTodo(Todo todo) async {
    // Ottiene l'istanza del database
    final db = await instance.database;
    // Inserisce il Todo (convertito in mappa) nella tabella "todos" e restituisce l'id del record inserito
    return await db.insert('todos', todo.toJson());
  }

  // Funzione per ottenere la lista di tutti i Todo presenti nel database
  Future<List<Todo>> getTodos(DateTime time) async {
    // Ottiene l'istanza del database
    final db = await instance.database;
    // Esegue una query sulla tabella "todos" per ottenere tutti i record
    final result = await db.query(
      'todos',
      where: 'DATE(dateTodo) = ?',
      whereArgs: [time],
    );
    // Converte il risultato (lista di mappe) in una lista di oggetti Todo
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  // Puoi aggiungere metodi per update e delete per completare le operazioni CRUD
  Future<void> updateTodo(Todo todo) async {
    final db = await instance.database;
    await db.update(
      'todos',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await instance.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  //CATEGORIE
  Future<int> insertCategory(CategoryModel category) async {
    final db = await instance.database;
    var res = await db.insert('category', category.toJson());
    return res;
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      final db = await instance.database;
      await db.update(
        'category',
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<(bool, String)> deleteCategory(int id) async {
    final db = await instance.database;
    var check = await db.query(
      'todos',
      columns: ['categoryId'],
      where: 'categoryId = ?',
      whereArgs: [id],
    );
    if (check.isEmpty) {
      int res = await db.delete('category', where: 'id = ?', whereArgs: [id]);
      if (res != 0) {
        return (true, "Ok");
      } else {
        return (false, "Qualcosa è andato storto :(");
      }
    } else {
      return (false, "La categoria è utilizzata, non è possibile eliminarla!");
    }
  }
}
