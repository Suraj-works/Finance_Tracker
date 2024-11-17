
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;


class DatabaseHelper {
  static final _databaseName = "finance_tracker.db";
  static final _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  factory DatabaseHelper(){
    return instance;
  }

  DatabaseHelper._privateConstructor();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future <Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    // Check if the database exists in the app's document directory
    bool dbExists = await databaseExists(path);

    if(!dbExists){
      // if the database does not exist, copy it from the assets folder
      ByteData data = await rootBundle.load(join('assets', _databaseName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // write the copied database to the document to the document directory
      await File(path).writeAsBytes(bytes);
    }
    // open the database and return its reference

    return await openDatabase(path, version: _databaseVersion);
  }

  // Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE Transactions (
  //     transaction_id INTEGER PRIMARY KEY,
  //     date TEXT,
  //     amount REAL,
  //     category_id INTEGER,
  //     notes TEXT,
  //     FOREIGN KEY (category_id) REFERENCES Categories(category_id)
  //   ''');
  //
  //   await db.execute('''
  //     CREATE TABLE Categories (
  //     category_id INTEGER PRIMARY KEY,
  //     category_name TEXT,
  //     type TEXT
  //   ''');
  //
  //   await db.execute('''
  //     CREATE TABLE Goals(
  //     goal_id INTEGER PRIMARY KEY,
  //     title TEXT,
  //     target_amount REAL,
  //     current_savings REAL,
  //     start_date TEXT,
  //     end_date TEXT,
  //     status TEXT,
  //   ''');
  //
  //
  // }

  // operations on Tables
  // Insert data to Transaction table
  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      'Transactions',
      transaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  // Retrieve data from Transaction table
  Future<List<Map<String, dynamic>>> getTransaction() async{
    final db = await DatabaseHelper().database;
    return await db.query('Transactions');
  }


  // update data in Transaction table

 Future<void> updateTransaction(int id, Map<String,dynamic> updateTransaction) async {
    final db = await DatabaseHelper().database;

    await db.update(
      'Transactions',
      updateTransaction,
      where: 'id = ?',
      whereArgs: [id],
    );
 }

 // delete data from Transactions table

  Future<void> deleteTransaction(int id) async {
    final db = await DatabaseHelper().database;

    await db.delete(
      'Transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // insert data to Categories table
  Future<void> insertCategory(Map<String, dynamic> category) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      'Categories',
      category,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve data from Categories table
  Future<List<Map<String, dynamic>>> getCategory() async{
    final db = await DatabaseHelper().database;
    return await db.query('Categories');
  }
  // update data in Categories table

  Future<void> updateCategory(int id, Map<String,dynamic> updateCategory) async {
    final db = await DatabaseHelper().database;

    await db.update(
      'Categories',
      updateCategory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete data from Categories table

  Future<void> deleteCategory(int id) async {
    final db = await DatabaseHelper().database;

    await db.delete(
      'Categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // insert data to Goals table

  Future<void> insertGoal(Map<String, dynamic> goal) async{
    final db = await DatabaseHelper().database;

    await db.insert(
      'Goals',
      goal,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve data from Goals table
  Future<List<Map<String, dynamic>>> getGoal() async{
    final db = await DatabaseHelper().database;
    return await db.query('Goals');
  }

  // update data in Goals table

  Future<void> updateGoal(int id, Map<String,dynamic> updateGoal) async {
    final db = await DatabaseHelper().database;

    await db.update(
      'Goals',
      updateGoal,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // delete data from transactions table

  Future<void> deleteGoal(int id) async {
    final db = await DatabaseHelper().database;

    await db.delete(
      'Goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // Queries for dashboard data
  // to get total income for current month

  Future<double> getTotalIncomeForCurrentMonth() async {
    final db = await DatabaseHelper().database;

    var result = await db.rawQuery('''
    SELECT SUM(t.amount) AS total_income
    FROM Transactions t 
    JOIN Categories c ON t.category_id = c.category_id
    WHERE c.type = 'Income'
    AND substr(t.date,4,2) = strftime('09')
    AND substr(t.date,7,4) = strftime('2024');
    ''');
    // Parse the result

    for(var i in result){
      print(i);
    }
    double totalIncome = result[0]['total_income'] != null
        ? double.tryParse(result[0]['total_income'].toString()) ?? 0.0
        : 0.0;
     return totalIncome;

  }

  // to get total expenses for the current month

  // Future<double> getTotalExpensesForCurrentMonth() async{
  //   final db = await DatabaseHelper().database;
  //
  //   var result = await db.rawQuery('''
  //   SELECT SUM(t.amount)
  //   ''');
  // }


}


