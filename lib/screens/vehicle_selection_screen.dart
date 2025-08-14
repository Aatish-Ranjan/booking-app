import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_card.dart';

class VehicleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleType? selectedType = 
        ModalRoute.of(context)?.settings.arguments as VehicleType?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Vehicle'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          final vehicles = selectedType != null
              ? bookingProvider.getVehiclesByType(selectedType)
              : bookingProvider.vehicles;

          if (vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No vehicles available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Vehicle Type Filter
              if (selectedType == null) ...[
                Container(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: VehicleType.values.map((type) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12, top: 8, bottom: 8),
                        child: FilterChip(
                          label: Text(type.displayName),
                          selected: false,
                          onSelected: (selected) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/vehicle-selection',
                              arguments: type,
                            );
                          },
                          selectedColor: Color(0xFF2E7D32),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Divider(),
              ],
              
              // Vehicles List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: VehicleCard(
                        vehicle: vehicle,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/booking-form',
                            arguments: vehicle,
                          );
                        },
                        showBookButton: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
