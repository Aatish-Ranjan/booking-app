import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../models/vehicle.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  BookingProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    // Mock vehicles data
    _vehicles = [
      Vehicle(
        id: '1',
        type: VehicleType.cab,
        name: 'Sedan Car',
        description: 'Comfortable sedan for city travel',
        pricePerHour: 200.0,
        pricePerKm: 12.0,
        capacity: 4,
        imageUrl: 'assets/images/sedan.png',
      ),
      Vehicle(
        id: '2',
        type: VehicleType.auto,
        name: 'Auto Rickshaw',
        description: 'Convenient auto for short distances',
        pricePerHour: 100.0,
        pricePerKm: 8.0,
        capacity: 3,
        imageUrl: 'assets/images/auto.png',
      ),
      Vehicle(
        id: '3',
        type: VehicleType.tractor,
        name: 'Farm Tractor',
        description: 'Heavy-duty tractor for agricultural work',
        pricePerHour: 500.0,
        pricePerKm: 25.0,
        capacity: 2,
        imageUrl: 'assets/images/tractor.png',
      ),
      Vehicle(
        id: '4',
        type: VehicleType.lorry,
        name: 'Goods Lorry',
        description: 'Large lorry for goods transportation',
        pricePerHour: 800.0,
        pricePerKm: 35.0,
        capacity: 2,
        imageUrl: 'assets/images/lorry.png',
      ),
    ];
  }

  Future<bool> createBooking({
    required String userId,
    required Vehicle vehicle,
    required String pickupLocation,
    required String dropLocation,
    required DateTime pickupDateTime,
    DateTime? returnDateTime,
    required TripType tripType,
    required int duration,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock API call
      await Future.delayed(Duration(seconds: 2));

      final estimatedPrice = _calculatePrice(vehicle, duration, tripType);
      
      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        vehicle: vehicle,
        pickupLocation: pickupLocation,
        dropLocation: dropLocation,
        pickupDateTime: pickupDateTime,
        returnDateTime: returnDateTime,
        tripType: tripType,
        duration: duration,
        estimatedPrice: estimatedPrice,
        status: BookingStatus.pending,
        notes: notes,
        createdAt: DateTime.now(),
      );

      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Create booking error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  double _calculatePrice(Vehicle vehicle, int duration, TripType tripType) {
    double basePrice = vehicle.pricePerHour * duration;
    if (tripType == TripType.roundTrip) {
      basePrice *= 1.8; // Round trip discount
    }
    return basePrice;
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 1));
      
      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        final updatedBooking = Booking(
          id: _bookings[index].id,
          userId: _bookings[index].userId,
          vehicle: _bookings[index].vehicle,
          pickupLocation: _bookings[index].pickupLocation,
          dropLocation: _bookings[index].dropLocation,
          pickupDateTime: _bookings[index].pickupDateTime,
          returnDateTime: _bookings[index].returnDateTime,
          tripType: _bookings[index].tripType,
          duration: _bookings[index].duration,
          estimatedPrice: _bookings[index].estimatedPrice,
          status: status,
          notes: _bookings[index].notes,
          createdAt: _bookings[index].createdAt,
        );
        _bookings[index] = updatedBooking;
      }
    } catch (e) {
      print('Update booking status error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(bookingId, BookingStatus.cancelled);
  }

  List<Booking> getUpcomingBookings() {
    return _bookings
        .where((booking) => 
            booking.status != BookingStatus.completed && 
            booking.status != BookingStatus.cancelled)
        .toList();
  }

  List<Booking> getPastBookings() {
    return _bookings
        .where((booking) => 
            booking.status == BookingStatus.completed || 
            booking.status == BookingStatus.cancelled)
        .toList();
  }

  List<Vehicle> getVehiclesByType(VehicleType type) {
    return _vehicles.where((vehicle) => vehicle.type == type).toList();
  }
}
