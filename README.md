# Advance Booking App

A Flutter mobile application for advance booking of cabs, tractors, lorries, and autos for intercity travel. The app features a modern UI similar to Ola, Uber, and Rapido.

## Features

### User Authentication
- Email/phone authentication
- User registration and login
- Profile management

### Vehicle Booking
- Support for multiple vehicle types:
  - Cab (Sedan cars)
  - Auto (Auto rickshaw)
  - Tractor (Agricultural/farm vehicles)
  - Lorry (Goods transportation)

### Advance Booking System
- Select pickup and drop locations
- Choose date and time for booking
- One-way and round-trip options
- Duration-based pricing
- Add special requirements/notes

### Booking Management
- View upcoming and past bookings
- Cancel pending bookings
- Real-time booking status updates
- Price estimates

### Modern UI/UX
- Clean, intuitive interface
- Material Design components
- Responsive design for different screen sizes
- Smooth animations and transitions

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── user.dart               # User model
│   ├── vehicle.dart            # Vehicle model and types
│   └── booking.dart            # Booking model and status
├── providers/                   # State management (Provider pattern)
│   ├── auth_provider.dart      # Authentication state
│   ├── booking_provider.dart   # Booking management
│   └── location_provider.dart  # Location services
├── screens/                     # UI screens
│   ├── splash_screen.dart      # Initial loading screen
│   ├── login_screen.dart       # Authentication screen
│   ├── home_screen.dart        # Main dashboard
│   ├── vehicle_selection_screen.dart
│   ├── booking_form_screen.dart
│   ├── booking_list_screen.dart
│   └── profile_screen.dart
├── widgets/                     # Reusable UI components
│   ├── vehicle_card.dart       # Vehicle display card
│   └── booking_card.dart       # Booking display card
└── services/                    # External services (ready for implementation)
```

## Dependencies

- **flutter**: SDK for cross-platform development
- **provider**: State management
- **geolocator**: Location services
- **permission_handler**: Device permissions
- **http**: API communication
- **shared_preferences**: Local storage
- **flutter_local_notifications**: Push notifications
- **url_launcher**: External URL handling
- **intl**: Date/time formatting
- **image_picker**: Profile image selection

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code with Flutter extension
- Android device/emulator or iOS device/simulator

### Installation

1. **Navigate to project directory**
   ```bash
   cd advance_booking_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable Developer Mode** (for Windows development)
   - Run `start ms-settings:developers` to enable Developer Mode

2. **Check Flutter setup**
   ```bash
   flutter doctor
   ```

3. **Run on specific platform**
   ```bash
   flutter run -d android    # Android
   flutter run -d ios        # iOS
   ```

## App Flow

1. **Splash Screen** → **Login/Register**
2. **Home Dashboard** with quick actions
3. **Vehicle Selection** by type or browse all
4. **Booking Form** with location, date/time, duration
5. **Booking Confirmation** with price estimate
6. **Booking Management** to view and manage bookings

## Key Features Implementation

### Authentication
- Mock authentication system (ready for backend integration)
- Persistent login state with SharedPreferences
- User profile management

### Booking System
- Advance booking (not real-time)
- Multiple vehicle types support
- Duration-based pricing calculation
- Trip type selection (one-way/round-trip)

### Location Services
- Current location detection
- Location search functionality
- Permission handling

### State Management
- Provider pattern for reactive UI
- Centralized state management
- Efficient rebuilds

## Customization

### Adding New Vehicle Types
1. Update `VehicleType` enum in `models/vehicle.dart`
2. Add corresponding icons and display names
3. Update vehicle cards and selection logic

### Backend Integration
Replace mock implementations in providers with actual API calls:
- `AuthProvider`: Connect to authentication service
- `BookingProvider`: Connect to booking management API
- `LocationProvider`: Integrate with maps/geocoding service

### UI Customization
- Update colors in `main.dart` theme
- Modify card designs in widgets
- Add custom animations and transitions

## Future Enhancements

- Real-time tracking integration
- Payment gateway integration
- Push notifications
- Driver assignment system
- Rating and review system
- Multi-language support
- Offline booking capability

## Testing

Run tests with:
```bash
flutter test
```

## Build for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Support

For development support or questions about the implementation, refer to:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design Guidelines](https://material.io/design)

---

**Note**: This is a demo application with mock data. For production use, implement proper backend services, security measures, and data validation.
