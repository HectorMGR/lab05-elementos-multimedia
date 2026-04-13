import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_vehicles.dart';
import '../../domain/usecases/add_vehicle.dart';
import '../../domain/usecases/update_vehicle.dart';
import '../../domain/usecases/delete_vehicle.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicles getVehicles;
  final AddVehicle addVehicle;
  final UpdateVehicle updateVehicle;
  final DeleteVehicle deleteVehicle;

  VehicleBloc({
    required this.getVehicles,
    required this.addVehicle,
    required this.updateVehicle,
    required this.deleteVehicle,
  }) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicleEvent>(_onAddVehicle);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
    on<DeleteVehicleEvent>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());
    try {
      final vehicles = await getVehicles();
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onAddVehicle(
    AddVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await addVehicle(event.vehicle);
      add(LoadVehicles());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await updateVehicle(event.vehicle);
      add(LoadVehicles());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await deleteVehicle(event.id);
      add(LoadVehicles());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }
}