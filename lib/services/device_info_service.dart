import 'package:flutter/services.dart';

class DeviceInfoService {
  static const _channel = MethodChannel('com.cinemascope.app/device_info');

  /// Returns a map with 'manufacturer' and 'model' on Android,
  /// or 'name' on iOS. Returns an error message string on failure.
  Future<Map<String, String>> getDeviceHardwareInfo() async {
    try {
      final result = await _channel.invokeMapMethod<String, String>(
        'getDeviceHardwareInfo',
      );
      return result ?? {'error': 'No data returned'};
    } on PlatformException catch (e) {
      return {'error': e.message ?? 'Unknown platform error'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}