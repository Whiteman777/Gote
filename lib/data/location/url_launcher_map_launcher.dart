import 'package:gote/domain/location/map_launcher.dart';
import 'package:gote/domain/location/map_link.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherMapLauncher implements MapLauncher {
  const UrlLauncherMapLauncher();

  @override
  Future<bool> open(MapLink link) async {
    return launchUrl(link.uri, mode: LaunchMode.externalApplication);
  }
}

class NoopMapLauncher implements MapLauncher {
  const NoopMapLauncher();

  @override
  Future<bool> open(MapLink link) async => false;
}
