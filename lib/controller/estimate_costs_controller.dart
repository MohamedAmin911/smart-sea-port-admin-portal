import 'dart:convert';
import 'dart:math';
import 'package:final_project_admin_website/constants/apis.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EstimateCostsController extends GetxController {
  RxInt estimatedCost = 0.obs;
  Future<Map<String, dynamic>> getCoordinates(String country) async {
    final url =
        'https://geocode.maps.co/search?q=$country&api_key=${KapiKeys.geoCodingApiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final location = jsonData[0];
      print(location);
      return {
        'lat': double.tryParse(location['lat']),
        'lng': double.tryParse(location['lon'])
      };
    } else {
      throw Exception('Failed to fetch coordinates for $country');
    }
  }

  double calculateDistanceKm(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;

  Future<int> estimateShipmentCost(
    String fromCountry,
    String toCountry, {
    required double length,
    required double width,
    required double height,
  }) async {
    final fromCoords = await getCoordinates(fromCountry);
    final toCoords = await getCoordinates(toCountry);

    final distance = calculateDistanceKm(
      fromCoords['lat']!,
      fromCoords['lng']!,
      toCoords['lat']!,
      toCoords['lng']!,
    );

    const baseCost = 1000.0;
    const costPerKm = 0.5;

    // Calculate volume in cubic meters
    final volume =
        (length / 100) * (width / 100) * (height / 100); // assuming cm input

    // Example customs fee: $20 per cubic meter
    const customsFeePerCubicMeter = 100.0;
    final customsFee = volume * customsFeePerCubicMeter;

    final costBeforeMultiplier = baseCost + (distance * costPerKm) + customsFee;

    final totalCost = costBeforeMultiplier.ceil() * 50;

    estimatedCost.value = totalCost;
    return totalCost;
  }

  Future<DateTime> estimateArrivalDate(
      String fromCountry, String toCountry) async {
    final fromCoords = await getCoordinates(fromCountry);
    final toCoords = await getCoordinates(toCountry);

    final distanceKm = calculateDistanceKm(
      fromCoords['lat']!,
      fromCoords['lng']!,
      toCoords['lat']!,
      toCoords['lng']!,
    );

    const averageSpeedKmPerHour = 60.0; // You can tweak this for realism
    final estimatedHours = distanceKm / averageSpeedKmPerHour;

    return DateTime.now().add(Duration(hours: estimatedHours.ceil()));
  }
}
