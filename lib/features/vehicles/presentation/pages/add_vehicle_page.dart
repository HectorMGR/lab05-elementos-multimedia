import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vehicle.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../widgets/vehicle_form.dart';

class AddVehiclePage extends StatelessWidget {
  final Vehicle? vehicle;

  const AddVehiclePage({super.key, this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isEditing = vehicle != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Vehículo' : 'Agregar Vehículo'),
      ),
      body: VehicleForm(
        vehicle: vehicle,
        onSubmit: (v) {
          if (isEditing) {
            context.read<VehicleBloc>().add(UpdateVehicleEvent(v));
          } else {
            context.read<VehicleBloc>().add(AddVehicleEvent(v));
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}