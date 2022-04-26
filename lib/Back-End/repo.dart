import 'package:sqflite/sqflite.dart';
import 'db_connection.dart';

class Repo {
  late DatabaseConnection _databaseConnection;
  Repo() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }
// deleteData(table,todoId) async{
//   var connection=await database;
//   return await connection?.rawDelete("delete from $table where id=$todoId");

// }
  updateData(table, data) async {
    var connection = await database;
    // return await connection?.update(table, data);
    return await connection?.rawUpdate('UPDATE $table  WHERE id = ?',
    data['id']);
  }
 }
