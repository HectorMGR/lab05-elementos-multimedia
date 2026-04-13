class Vehicle {
  final int? id;
  final String brand;
  final String model;
  final int year;
  final double price;
  final String description;
  final String? imageUrl;

  Vehicle({
    this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.description,
    this.imageUrl,
  });
}