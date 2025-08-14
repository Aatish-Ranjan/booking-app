import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/booking_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickBook'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildBookingsTab(),
          _buildVehiclesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2E7D32),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicles',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Consumer2<AuthProvider, BookingProvider>(
      builder: (context, authProvider, bookingProvider, child) {
        final upcomingBookings = bookingProvider.getUpcomingBookings();
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${authProvider.user?.name ?? "User"}!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Where would you like to go today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/vehicle-selection');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      'Cab',
                      Icons.directions_car,
                      () => _navigateToVehicleSelection(VehicleType.cab),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      'Auto',
                      Icons.directions_car,
                      () => _navigateToVehicleSelection(VehicleType.auto),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      'Tractor',
                      Icons.agriculture,
                      () => _navigateToVehicleSelection(VehicleType.tractor),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      'Lorry',
                      Icons.local_shipping,
                      () => _navigateToVehicleSelection(VehicleType.lorry),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              // Upcoming Bookings
              if (upcomingBookings.isNotEmpty) ...[
                Text(
                  'Upcoming Bookings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ...upcomingBookings.take(3).map((booking) => 
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: BookingCard(booking: booking),
                  ),
                ),
                if (upcomingBookings.length > 3)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Text('View All Bookings'),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: Color(0xFF2E7D32),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final upcomingBookings = bookingProvider.getUpcomingBookings();
        final pastBookings = bookingProvider.getPastBookings();
        
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Color(0xFF2E7D32),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF2E7D32),
                tabs: [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBookingsList(upcomingBookings),
                    _buildBookingsList(pastBookings),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingsList(List bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start by booking a vehicle',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: BookingCard(booking: bookings[index]),
        );
      },
    );
  }

  Widget _buildVehiclesTab() {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: bookingProvider.vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = bookingProvider.vehicles[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: VehicleCard(
                vehicle: vehicle,
                onTap: () => _navigateToBookingForm(vehicle),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToVehicleSelection(VehicleType type) {
    Navigator.pushNamed(
      context,
      '/vehicle-selection',
      arguments: type,
    );
  }

  void _navigateToBookingForm(vehicle) {
    Navigator.pushNamed(
      context,
      '/booking-form',
      arguments: vehicle,
    );
  }
}
