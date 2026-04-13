import 'package:flutter/material.dart';
import '../../domain/entities/vehicle.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;
  final Function(Vehicle) onSubmit;

  const VehicleForm({
    super.key,
    this.vehicle,
    required this.onSubmit,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.vehicle?.brand ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(
      text: widget.vehicle?.year.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.vehicle?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.vehicle?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.vehicle?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        id: widget.vehicle?.id,
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );
      widget.onSubmit(vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: 'Marca',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.branding_watermark),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Ingrese la marca' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'Modelo',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.model_training),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Ingrese el modelo' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _yearController,
            decoration: const InputDecoration(
              labelText: 'Año',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingrese el año';
              final year = int.tryParse(v.trim());
              if (year == null || year < 1900 || year > 2030) {
                return 'Año inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Precio',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingrese el precio';
              if (double.tryParse(v.trim()) == null) return 'Precio inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Ingrese una descripción'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL de imagen (opcional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: Icon(
              widget.vehicle == null ? Icons.add : Icons.save,
            ),
            label: Text(
              widget.vehicle == null ? 'Agregar Vehículo' : 'Guardar Cambios',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}