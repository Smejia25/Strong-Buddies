import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class LocationService {
  final _geo = Location();
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();

  Future<GeoFirePoint> getPermissions() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {

        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    }
    _locationData = await location.getLocation();
    GeoFirePoint myLocation = geo.point(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    return myLocation;
  }

  Future<GeoFirePoint> getCurrentLocation() async {
    LocationData _locationData;

    _locationData = await location.getLocation();

    GeoFirePoint myLocation = geo.point(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    return myLocation;
  }
}
