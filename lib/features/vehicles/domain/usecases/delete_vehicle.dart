import '../repositories/vehicle_repository.dart';

class DeleteVehicle {
  final VehicleRepository repository;

  DeleteVehicle(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteVehicle(id);
  }
}