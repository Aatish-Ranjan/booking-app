import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/location_provider.dart';
import '../models/vehicle.dart';
import '../models/booking.dart';

class BookingFormScreen extends StatefulWidget {
  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _pickupDateTime;
  DateTime? _returnDateTime;
  TripType _tripType = TripType.oneWay;
  int _duration = 1;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Vehicle vehicle = ModalRoute.of(context)!.settings.arguments as Vehicle;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${vehicle.name}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Info Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getVehicleIcon(vehicle.type),
                          size: 30,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              vehicle.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${vehicle.pricePerHour}/hour • ₹${vehicle.pricePerKm}/km',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Pickup Location
              Text(
                'Pickup Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _pickupController,
                decoration: InputDecoration(
                  hintText: 'Enter pickup location',
                  prefixIcon: Icon(Icons.location_on, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pickup location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Drop Location
              Text(
                'Drop Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _dropController,
                decoration: InputDecoration(
                  hintText: 'Enter drop location',
                  prefixIcon: Icon(Icons.location_on, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter drop location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Trip Type
              Text(
                'Trip Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<TripType>(
                      title: Text('One Way'),
                      value: TripType.oneWay,
                      groupValue: _tripType,
                      onChanged: (value) {
                        setState(() {
                          _tripType = value!;
                          _returnDateTime = null;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<TripType>(
                      title: Text('Round Trip'),
                      value: TripType.roundTrip,
                      groupValue: _tripType,
                      onChanged: (value) {
                        setState(() {
                          _tripType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Pickup Date and Time
              Text(
                'Pickup Date & Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: _selectPickupDateTime,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                      SizedBox(width: 12),
                      Text(
                        _pickupDateTime != null
                            ? DateFormat('dd MMM yyyy, hh:mm a').format(_pickupDateTime!)
                            : 'Select pickup date & time',
                        style: TextStyle(
                          fontSize: 16,
                          color: _pickupDateTime != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Return Date and Time (for round trip)
              if (_tripType == TripType.roundTrip) ...[
                Text(
                  'Return Date & Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: _selectReturnDateTime,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                        SizedBox(width: 12),
                        Text(
                          _returnDateTime != null
                              ? DateFormat('dd MMM yyyy, hh:mm a').format(_returnDateTime!)
                              : 'Select return date & time',
                          style: TextStyle(
                            fontSize: 16,
                            color: _returnDateTime != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Duration
              Text(
                'Duration (Hours)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _duration.toDouble(),
                      min: 1,
                      max: 24,
                      divisions: 23,
                      label: '$_duration hours',
                      activeColor: Color(0xFF2E7D32),
                      onChanged: (value) {
                        setState(() {
                          _duration = value.round();
                        });
                      },
                    ),
                  ),
                  Text(
                    '$_duration hrs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Notes
              Text(
                'Additional Notes (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any special requirements or notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Price Estimate
              Card(
                color: Color(0xFF2E7D32).withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Estimate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base Price ($_duration hrs)'),
                          Text('₹${(vehicle.pricePerHour * _duration).toStringAsFixed(0)}'),
                        ],
                      ),
                      if (_tripType == TripType.roundTrip) ...[
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Round Trip Discount (10%)'),
                            Text('-₹${(vehicle.pricePerHour * _duration * 0.1).toStringAsFixed(0)}'),
                          ],
                        ),
                      ],
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${_calculateTotalPrice(vehicle).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Book Button
              Consumer2<AuthProvider, BookingProvider>(
                builder: (context, authProvider, bookingProvider, child) {
                  return ElevatedButton(
                    onPressed: bookingProvider.isLoading ? null : () => _submitBooking(vehicle, authProvider, bookingProvider),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: bookingProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Book Now',
                            style: TextStyle(fontSize: 18),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.cab:
        return Icons.directions_car;
      case VehicleType.auto:
        return Icons.directions_car;
      case VehicleType.tractor:
        return Icons.agriculture;
      case VehicleType.lorry:
        return Icons.local_shipping;
    }
  }

  void _getCurrentLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getCurrentLocation();
    
    if (locationProvider.currentAddress != null) {
      _pickupController.text = locationProvider.currentAddress!;
    }
  }

  Future<void> _selectPickupDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _pickupDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectReturnDateTime() async {
    if (_pickupDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select pickup date first')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _pickupDateTime!.add(Duration(days: 1)),
      firstDate: _pickupDateTime!,
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _returnDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  double _calculateTotalPrice(Vehicle vehicle) {
    double basePrice = vehicle.pricePerHour * _duration;
    if (_tripType == TripType.roundTrip) {
      basePrice *= 0.9; // 10% discount for round trip
    }
    return basePrice;
  }

  Future<void> _submitBooking(Vehicle vehicle, AuthProvider authProvider, BookingProvider bookingProvider) async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_pickupDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select pickup date and time')),
      );
      return;
    }

    if (_tripType == TripType.roundTrip && _returnDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select return date and time')),
      );
      return;
    }

    final success = await bookingProvider.createBooking(
      userId: authProvider.user!.id,
      vehicle: vehicle,
      pickupLocation: _pickupController.text,
      dropLocation: _dropController.text,
      pickupDateTime: _pickupDateTime!,
      returnDateTime: _returnDateTime,
      tripType: _tripType,
      duration: _duration,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
