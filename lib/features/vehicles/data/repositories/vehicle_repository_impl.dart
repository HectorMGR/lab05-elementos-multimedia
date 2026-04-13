import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_local_datasource.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleLocalDataSource datasource;

  VehicleRepositoryImpl(this.datasource);

  @override
  Future<List<Vehicle>> getVehicles() async {
    return await datasource.getVehicles();
  }

  @override
  Future<Vehicle?> getVehicleById(int id) async {
    return await datasource.getVehicleById(id);
  }

  @override
  Future<void> addVehicle(Vehicle vehicle) async {
    final model = VehicleModel.fromEntity(vehicle);
    await datasource.addVehicle(model);
  }

  @override
  Future<void> updateVehicle(Vehicle vehicle) async {
    final model = VehicleModel.fromEntity(vehicle);
    await datasource.updateVehicle(model);
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await datasource.deleteVehicle(id);
  }
}