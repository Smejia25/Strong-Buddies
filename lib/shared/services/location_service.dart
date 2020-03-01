import 'package:location/location.dart';

class LocationService {
  final _geo = Location();

  Future<LocationData> getCurrentLocation() async {
    if (!(await handlePermissions())) return null;
    return _geo.getLocation();
  }

  Future<bool> handlePermissions() async {
    return (await _geo.hasPermission() || await _geo.requestPermission()) &&
        (await _geo.serviceEnabled() || await _geo.requestService());
  }
}
