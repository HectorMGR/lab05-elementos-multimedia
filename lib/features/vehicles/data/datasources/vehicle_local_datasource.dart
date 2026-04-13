import 'package:sqflite/sqflite.dart';
import '../../../../core/services/database_service.dart';
import '../models/vehicle_model.dart';

abstract class VehicleLocalDataSource {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel?> getVehicleById(int id);
  Future<void> addVehicle(VehicleModel vehicle);
  Future<void> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(int id);
}

class VehicleLocalDataSourceImpl implements VehicleLocalDataSource {
  @override
  Future<List<VehicleModel>> getVehicles() async {
    final db = await DatabaseService.database;
    final maps = await db.query('vehicles', orderBy: 'id DESC');
    return maps.map((map) => VehicleModel.fromMap(map)).toList();
  }

  @override
  Future<VehicleModel?> getVehicleById(int id) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return VehicleModel.fromMap(maps.first);
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    final db = await DatabaseService.database;
    await db.insert('vehicles', vehicle.toMap());
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    final db = await DatabaseService.database;
    await db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  @override
  Future<void> deleteVehicle(int id) async {
    final db = await DatabaseService.database;
    await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}