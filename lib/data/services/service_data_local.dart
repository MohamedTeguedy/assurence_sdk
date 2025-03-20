import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car_model.dart';

class CarService {
  static final CarService _instance = CarService._internal();
  static Database? _database;

  factory CarService() {
    return _instance;
  }

  CarService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cars.db');
    // Supprimer la base de données existante (uniquement pour le développement)
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1, // Assurez-vous que la version est correcte
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cars1(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vin TEXT,
        matricule TEXT,
        marque TEXT,
        modele TEXT,
        annee INTEGER,
        nom_proprietaire TEXT,
        usage TEXT,
        puissance TEXT,
        nbre_place INTEGER,
        types_couverture TEXT,
        durée TEXT
      )
    ''');
  }

  Future<int> insertCar(Car car) async {
    Database db = await database;
    return await db.insert('cars1', car.toMap());
  }

  Future<List<Car>> getCars() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('cars1');
    return List.generate(maps.length, (i) {
      return Car.fromMap(maps[i]);
    });
  }
}
