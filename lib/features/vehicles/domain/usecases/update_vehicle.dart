import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class UpdateVehicle {
  final VehicleRepository repository;

  UpdateVehicle(this.repository);

  Future<void> call(Vehicle vehicle) async {
    return await repository.updateVehicle(vehicle);
  }
}