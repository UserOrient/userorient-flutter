import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FeedbackMetaData {
  static Future<Map<String, dynamic>> collect() async {
    try {
      final List<Map<String, dynamic>> results = await Future.wait([
        _collectAppInfo(),
        _collectDeviceInfo(),
      ].map(
        (Future<Map<String, dynamic>> future) {
          return future.timeout(const Duration(seconds: 1));
        },
      ));

      final Map<String, dynamic> map = <String, dynamic>{};
      for (final Map<String, dynamic> r in results) {
        map.addAll(r);
      }

      return map;
    } catch (_) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> _collectAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    return {
      'app_version': info.version,
    };
  }

  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final DeviceInfoPlugin plugin = DeviceInfoPlugin();
    final Map<String, dynamic> data = <String, dynamic>{};

    if (kIsWeb) {
      data['platform'] = 'web';
      final WebBrowserInfo webInfo = await plugin.webBrowserInfo;
      data['os_version'] = webInfo.userAgent;

      return data;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        data['platform'] = 'android';
        final AndroidDeviceInfo info = await plugin.androidInfo;
        data['os_version'] = info.version.release;
        data['device_model'] = info.model;
        break;

      case TargetPlatform.iOS:
        data['platform'] = 'ios';
        final IosDeviceInfo info = await plugin.iosInfo;
        data['os_version'] = info.systemVersion;
        data['device_model'] = info.model;
        break;

      case TargetPlatform.macOS:
        data['platform'] = 'macos';
        final MacOsDeviceInfo info = await plugin.macOsInfo;
        data['os_version'] =
            '${info.majorVersion}.${info.minorVersion}.${info.patchVersion}';
        data['device_model'] = info.model;
        break;

      case TargetPlatform.windows:
        data['platform'] = 'windows';
        final WindowsDeviceInfo info = await plugin.windowsInfo;
        data['os_version'] = '${info.majorVersion}.${info.minorVersion}';
        break;

      case TargetPlatform.linux:
        data['platform'] = 'linux';
        final LinuxDeviceInfo info = await plugin.linuxInfo;
        data['os_version'] = info.version;
        break;

      default:
        data['platform'] = 'unknown';
        break;
    }

    return data;
  }
}
