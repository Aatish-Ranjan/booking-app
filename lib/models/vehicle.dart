enum VehicleType {
  cab,
  tractor,
  lorry,
  auto,
}

class Vehicle {
  final String id;
  final VehicleType type;
  final String name;
  final String description;
  final double pricePerHour;
  final double pricePerKm;
  final int capacity;
  final String imageUrl;

  Vehicle({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.pricePerKm,
    required this.capacity,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'name': name,
      'description': description,
      'pricePerHour': pricePerHour,
      'pricePerKm': pricePerKm,
      'capacity': capacity,
      'imageUrl': imageUrl,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      type: VehicleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      name: json['name'],
      description: json['description'],
      pricePerHour: json['pricePerHour'].toDouble(),
      pricePerKm: json['pricePerKm'].toDouble(),
      capacity: json['capacity'],
      imageUrl: json['imageUrl'],
    );
  }
}

extension VehicleTypeExtension on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.cab:
        return 'Cab';
      case VehicleType.tractor:
        return 'Tractor';
      case VehicleType.lorry:
        return 'Lorry';
      case VehicleType.auto:
        return 'Auto';
    }
  }

  String get iconName {
    switch (this) {
      case VehicleType.cab:
        return 'directions_car';
      case VehicleType.tractor:
        return 'agriculture';
      case VehicleType.lorry:
        return 'local_shipping';
      case VehicleType.auto:
        return 'directions_car';
    }
  }
}
