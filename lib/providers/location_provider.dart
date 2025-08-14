import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _error;

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Permission.location.request();
      return permission.isGranted;
    } catch (e) {
      _error = 'Failed to request location permission: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Location services are disabled';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permission denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permissions are permanently denied';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Mock address - in a real app, you would use geocoding
      _currentAddress = 'Current Location';
      
    } catch (e) {
      _error = 'Failed to get current location: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock method to search for places
  Future<List<String>> searchPlaces(String query) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    // Mock search results
    if (query.isEmpty) return [];
    
    return [
      '$query - Main Area',
      '$query - City Center',
      '$query - Airport',
      '$query - Railway Station',
      '$query - Bus Stand',
    ];
  }

  double calculateDistance(String from, String to) {
    // Mock distance calculation - in a real app, you would use actual coordinates
    return 25.5; // km
  }
}
