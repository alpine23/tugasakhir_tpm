import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class TimezoneService {
  TimezoneService() {
    tz.initializeTimeZones();
  }

  String getCurrentDateTime(String timeZone) {
    final location = tz.getLocation(timeZone);
    final now = tz.TZDateTime.now(location);
    return DateFormat('dd-MM-yyyy \t\t\t\t\t\t\t\t\t\t\t\t\t\t HH:mm:ss')
        .format(now);
  }

  void setLocalLocation(String timeZone) {
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
