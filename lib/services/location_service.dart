import 'dart:core';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'location_service.g.dart';// Import the notification service


class LocationService {
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // in meters
      ),
    );
  }

  Future<bool> isWithinRegion(
      Position position, double lat, double lon, double radius) async {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      lon,
    );
    return distance <= radius;
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}


@Riverpod(keepAlive: true)
Stream<Position> location(LocationRef ref) async* {
    final locationService = ref.watch(locationServiceProvider);
      await for (final position in locationService.getPositionStream()) {
    const double targetLat = 37.4219999; // Target latitude
    const double targetLon = -122.0840575; // Target longitude
    const double radius = 100.0; // Radius in meters

    bool isWithin = await locationService.isWithinRegion(position, targetLat, targetLon, radius);

    // if (isWithin) {
    //   await showNotification('Location Alert', 'You have entered the target region.');
    // }

    yield position;
  }
}