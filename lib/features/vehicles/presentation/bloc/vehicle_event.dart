import '../../domain/entities/vehicle.dart';

abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicleEvent(this.vehicle);
}

class UpdateVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;
  UpdateVehicleEvent(this.vehicle);
}

class DeleteVehicleEvent extends VehicleEvent {
  final int id;
  DeleteVehicleEvent(this.id);
}