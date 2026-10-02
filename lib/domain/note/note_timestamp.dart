import 'package:intl/intl.dart';

class NoteTimestamp {
  const NoteTimestamp._();

  static const int unset = 0;

  static final DateFormat _dayAndTime = DateFormat('d MMM y, HH:mm');
  static final DateFormat _timeOnly = DateFormat('HH:mm');

  static bool isUnset(int epochMillis) => epochMillis <= unset;

  static DateTime? toDateTime(int epochMillis) {
    if (isUnset(epochMillis)) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(epochMillis);
  }

  static String format(int epochMillis) {
    final DateTime? moment = toDateTime(epochMillis);
    return moment == null ? '' : _dayAndTime.format(moment);
  }

  static String formatPair(int createdAt, int updatedAt) {
    final String created = format(createdAt);
    if (created.isEmpty) {
      return '';
    }

    final DateTime? createdMoment = toDateTime(createdAt);
    final DateTime? updatedMoment = toDateTime(updatedAt);
    if (updatedMoment == null || createdMoment == null) {
      return created;
    }

    final bool sameDay =
        createdMoment.year == updatedMoment.year &&
        createdMoment.month == updatedMoment.month &&
        createdMoment.day == updatedMoment.day;

    return sameDay
        ? '$created · ${_timeOnly.format(updatedMoment)}'
        : '$created · ${format(updatedAt)}';
  }
}
