import 'vehicle.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

enum TripType {
  oneWay,
  roundTrip,
}

class Booking {
  final String id;
  final String userId;
  final Vehicle vehicle;
  final String pickupLocation;
  final String dropLocation;
  final DateTime pickupDateTime;
  final DateTime? returnDateTime;
  final TripType tripType;
  final int duration; // in hours
  final double estimatedPrice;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.vehicle,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupDateTime,
    this.returnDateTime,
    required this.tripType,
    required this.duration,
    required this.estimatedPrice,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vehicle': vehicle.toJson(),
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupDateTime': pickupDateTime.toIso8601String(),
      'returnDateTime': returnDateTime?.toIso8601String(),
      'tripType': tripType.toString().split('.').last,
      'duration': duration,
      'estimatedPrice': estimatedPrice,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      vehicle: Vehicle.fromJson(json['vehicle']),
      pickupLocation: json['pickupLocation'],
      dropLocation: json['dropLocation'],
      pickupDateTime: DateTime.parse(json['pickupDateTime']),
      returnDateTime: json['returnDateTime'] != null
          ? DateTime.parse(json['returnDateTime'])
          : null,
      tripType: TripType.values.firstWhere(
        (e) => e.toString().split('.').last == json['tripType'],
      ),
      duration: json['duration'],
      estimatedPrice: json['estimatedPrice'].toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

extension TripTypeExtension on TripType {
  String get displayName {
    switch (this) {
      case TripType.oneWay:
        return 'One Way';
      case TripType.roundTrip:
        return 'Round Trip';
    }
  }
}
