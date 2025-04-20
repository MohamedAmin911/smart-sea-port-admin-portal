import 'dart:convert';
import 'dart:math';
import 'package:final_project_admin_website/constants/apis.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

class EstimateCostsController extends GetxController {
  RxDouble estimatedCost = 0.0.obs;
  Future<Map<String, double>> getCoordinates(String country) async {
    final url =
        'https://maps.gomaps.pro/maps/api/geocode/json?address=$country&key=${KapiKeys.googleMapsApiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final location = jsonData['results'][0]['geometry']['location'];
      return {'lat': location['lat'], 'lng': location['lng']};
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

  Future<double> estimateShipmentCost(
      String fromCountry, String toCountry) async {
    final fromCoords = await getCoordinates(fromCountry);
    final toCoords = await getCoordinates(toCountry);

    final distance = calculateDistanceKm(
      fromCoords['lat']!,
      fromCoords['lng']!,
      toCoords['lat']!,
      toCoords['lng']!,
    );

    const baseCost = 100.0;
    const costPerKm = 0.5;
    estimatedCost.value = (baseCost + (distance * costPerKm)).ceil() * 50;
    return (baseCost + (distance * costPerKm)).ceil() * 50;
  }
}
