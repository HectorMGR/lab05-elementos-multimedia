import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.price,
    required super.description,
    super.imagePaths = const [],
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map,
      {List<String> imagePaths = const []}) {
    return VehicleModel(
      id: map['id'] as int?,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      imagePaths: imagePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'price': price,
      'description': description,
    };
  }

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      price: vehicle.price,
      description: vehicle.description,
      imagePaths: vehicle.imagePaths,
    );
  }
}