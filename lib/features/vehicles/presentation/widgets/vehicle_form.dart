import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  List<String> _imagePaths = [];
  bool _imageError = false;

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
    _imagePaths = List.from(widget.vehicle?.imagePaths ?? []);
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    if (source == ImageSource.gallery) {
      // Permitir selección múltiple desde galería
      final picked = await picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked.isNotEmpty) {
        setState(() {
          _imagePaths.addAll(picked.map((f) => f.path));
          _imageError = false;
        });
      }
    } else {
      // Cámara: una foto a la vez
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _imagePaths.add(picked.path);
          _imageError = false;
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería (múltiples)'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    final hasImages = _imagePaths.isNotEmpty;

    setState(() {
      _imageError = !hasImages;
    });

    if (formValid && hasImages) {
      final vehicle = Vehicle(
        id: widget.vehicle?.id,
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        imagePaths: _imagePaths,
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
          // Galería de imágenes seleccionadas
          if (_imagePaths.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePaths[index]),
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),

          // Botón para agregar imágenes
          OutlinedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.add_a_photo),
            label: Text(
              _imagePaths.isEmpty
                  ? 'Agregar imágenes *'
                  : 'Agregar más imágenes (${_imagePaths.length})',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: _imageError ? Colors.red : Colors.grey.shade400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (_imageError)
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 12),
              child: Text(
                'Debe agregar al menos una imagen',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),

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