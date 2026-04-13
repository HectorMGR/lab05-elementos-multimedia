import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class AddVehicle {
  final VehicleRepository repository;

  AddVehicle(this.repository);

  Future<void> call(Vehicle vehicle) async {
    return await repository.addVehicle(vehicle);
  }
}