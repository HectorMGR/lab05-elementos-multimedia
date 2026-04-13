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
  Future<List<String>> _getImagesForVehicle(Database db, int vehicleId) async {
    final maps = await db.query(
      'vehicle_images',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
    );
    return maps.map((m) => m['imagePath'] as String).toList();
  }

  Future<void> _saveImages(Database db, int vehicleId, List<String> paths) async {
    // Borrar imágenes anteriores
    await db.delete('vehicle_images', where: 'vehicleId = ?', whereArgs: [vehicleId]);
    // Insertar las nuevas
    for (final path in paths) {
      await db.insert('vehicle_images', {
        'vehicleId': vehicleId,
        'imagePath': path,
      });
    }
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final db = await DatabaseService.database;
    final maps = await db.query('vehicles', orderBy: 'id DESC');
    final List<VehicleModel> vehicles = [];
    for (final map in maps) {
      final images = await _getImagesForVehicle(db, map['id'] as int);
      vehicles.add(VehicleModel.fromMap(map, imagePaths: images));
    }
    return vehicles;
  }

  @override
  Future<VehicleModel?> getVehicleById(int id) async {
    final db = await DatabaseService.database;
    final maps = await db.query('vehicles', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final images = await _getImagesForVehicle(db, id);
    return VehicleModel.fromMap(maps.first, imagePaths: images);
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    final db = await DatabaseService.database;
    final vehicleId = await db.insert('vehicles', vehicle.toMap());
    await _saveImages(db, vehicleId, vehicle.imagePaths);
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
    await _saveImages(db, vehicle.id!, vehicle.imagePaths);
  }

  @override
  Future<void> deleteVehicle(int id) async {
    final db = await DatabaseService.database;
    await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }
}