import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicles {
  final VehicleRepository repository;

  GetVehicles(this.repository);

  Future<List<Vehicle>> call() async {
    return await repository.getVehicles();
  }
}