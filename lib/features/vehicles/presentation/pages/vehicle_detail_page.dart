import 'package:flutter/material.dart';
import '../../domain/entities/vehicle.dart';
import 'add_vehicle_page.dart';

class VehicleDetailPage extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.brand} ${vehicle.model}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVehiclePage(vehicle: vehicle),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 64,
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Marca', vehicle.brand),
            _buildInfoRow('Modelo', vehicle.model),
            _buildInfoRow('Año', vehicle.year.toString()),
            _buildInfoRow('Precio', '\$${vehicle.price.toStringAsFixed(2)}'),
            const Divider(height: 32),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vehicle.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            if (vehicle.imageUrl != null && vehicle.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Imagen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  vehicle.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(child: Text('No se pudo cargar')),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}