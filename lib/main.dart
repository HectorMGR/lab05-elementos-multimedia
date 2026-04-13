import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/vehicles/data/datasources/vehicle_local_datasource.dart';
import 'features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'features/vehicles/domain/usecases/get_vehicles.dart';
import 'features/vehicles/domain/usecases/add_vehicle.dart';
import 'features/vehicles/domain/usecases/update_vehicle.dart';
import 'features/vehicles/domain/usecases/delete_vehicle.dart';
import 'features/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'features/vehicles/presentation/bloc/vehicle_event.dart';
import 'features/vehicles/presentation/pages/vehicle_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyección de dependencias manual
    final datasource = VehicleLocalDataSourceImpl();
    final repository = VehicleRepositoryImpl(datasource);
    final getVehicles = GetVehicles(repository);
    final addVehicle = AddVehicle(repository);
    final updateVehicle = UpdateVehicle(repository);
    final deleteVehicle = DeleteVehicle(repository);

    return BlocProvider(
      create: (_) => VehicleBloc(
        getVehicles: getVehicles,
        addVehicle: addVehicle,
        updateVehicle: updateVehicle,
        deleteVehicle: deleteVehicle,
      )..add(LoadVehicles()),
      child: MaterialApp(
        title: 'Catálogo de Vehículos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const VehicleListPage(),
      ),
    );
  }
}