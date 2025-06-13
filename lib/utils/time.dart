import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

// Format time as DD/MM/YYYY HH:mm:ss
String formatTime(String time) {
  return Moment.parse(time).format('DD/MM/YYYY HH:mm:ss');
}

// Convert to UTC format (YYYY-MM-DDTHH:mm:ssZ)
String toUTC(dynamic time) {
  final date = time is DateTime ? time : Moment.parse(time).date;
  return Moment(date).toUtc().format('YYYY-MM-DDTHH:mm:ss[Z]');
}

// Format date as DD/MM/YYYY or localized format
String formatDate(DateTime date, {String? locale}) {
  if (locale != null) {
    return DateFormat.yMMMMd(locale).format(date);
  }
  return Moment(date).format('DD/MM/YYYY');
}

// Format time range (e.g., "Today", "This week", or "DD/MM - DD/MM/YYYY")
String formatTimeRange(
  String begin,
  String end,
  String Function(String) translate,
) {
  final beginDate = DateTime.parse(begin);
  final endDate = DateTime.parse(end);
  final now = DateTime.now();

  // Week calculations (assuming week starts on Sunday)
  final thisWeekStart = now.subtract(Duration(days: now.weekday % 7));
  final thisWeekEnd = thisWeekStart.add(
    Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
  );
  final lastWeekStart = thisWeekStart.subtract(Duration(days: 7));
  final lastWeekEnd = lastWeekStart.add(
    Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
  );
  final nextWeekStart = thisWeekStart.add(Duration(days: 7));
  final nextWeekEnd = nextWeekStart.add(
    Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
  );

  // Month calculations
  final thisMonthStart = DateTime(now.year, now.month, 1);
  final thisMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  final lastMonthStart = DateTime(now.year, now.month - 1, 1);
  final lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
  final nextMonthStart = DateTime(now.year, now.month + 1, 1);
  final nextMonthEnd = DateTime(now.year, now.month + 2, 0, 23, 59, 59);

  // Year calculations
  final thisYearStart = DateTime(now.year, 1, 1);
  final thisYearEnd = DateTime(now.year, 12, 31, 23, 59, 59);
  final lastYearStart = DateTime(now.year - 1, 1, 1);
  final lastYearEnd = DateTime(now.year - 1, 12, 31, 23, 59, 59);
  final nextYearStart = DateTime(now.year + 1, 1, 1);
  final nextYearEnd = DateTime(now.year + 1, 12, 31, 23, 59, 59);

  if (isToday(beginDate) && isToday(endDate)) return translate('Today');
  if (isTomorrow(beginDate) && isTomorrow(endDate))
    return translate('Tomorrow');
  if (isYesterday(beginDate) && isYesterday(endDate))
    return translate('Yesterday');
  if (isSameDate(beginDate, thisWeekStart) &&
      isSameDate(endDate, thisWeekEnd)) {
    return translate('This week');
  }
  if (isSameDate(beginDate, lastWeekStart) &&
      isSameDate(endDate, lastWeekEnd)) {
    return translate('Last week');
  }
  if (isSameDate(beginDate, nextWeekStart) &&
      isSameDate(endDate, nextWeekEnd)) {
    return translate('Next week');
  }
  if (isSameDate(beginDate, thisMonthStart) &&
      isSameDate(endDate, thisMonthEnd)) {
    return translate('This month');
  }
  if (isSameDate(beginDate, lastMonthStart) &&
      isSameDate(endDate, lastMonthEnd)) {
    return translate('Last month');
  }
  if (isSameDate(beginDate, nextMonthStart) &&
      isSameDate(endDate, nextMonthEnd)) {
    return translate('Next month');
  }
  if (isSameDate(beginDate, thisYearStart) &&
      isSameDate(endDate, thisYearEnd)) {
    return translate('This year');
  }
  if (isSameDate(beginDate, lastYearStart) &&
      isSameDate(endDate, lastYearEnd)) {
    return translate('Last year');
  }
  if (isSameDate(beginDate, nextYearStart) &&
      isSameDate(endDate, nextYearEnd)) {
    return translate('Next year');
  }

  final beginFormat = isSameYear(beginDate, endDate) ? 'dd/MM' : 'dd/MM/yyyy';
  final endFormat = 'dd/MM/yyyy';
  return '${DateFormat(beginFormat).format(beginDate)} - ${DateFormat(endFormat).format(endDate)}';
}

// Check if two dates are the same (year, month, day)
bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

// Check if a date is today
bool isToday(DateTime date) {
  return isSameDate(date, DateTime.now());
}

// Check if a date is tomorrow
bool isTomorrow(DateTime date) {
  final tomorrow = DateTime.now().add(Duration(days: 1));
  return isSameDate(date, tomorrow);
}

// Check if a date is yesterday
bool isYesterday(DateTime date) {
  final yesterday = DateTime.now().subtract(Duration(days: 1));
  return isSameDate(date, yesterday);
}

// Check if two dates are in the same year
bool isSameYear(DateTime date1, DateTime date2) {
  return date1.year == date2.year;
}

// Get time remaining (e.g., "1d:2h:3m" or object)
dynamic getTimeRemaining(dynamic expireDate, {bool isReturnObject = false}) {
  final now = Moment.now();
  final expiration = expireDate is DateTime
      ? Moment(expireDate)
      : Moment.parse(expireDate);
  final diff = expiration.difference(now);

  final years = diff.inYears;
  final months = diff.inMonths % 12;
  final days = diff.inDays % 30;
  final hours = diff.inHours % 24;
  final minutes = diff.inMinutes % 60;

  if (isReturnObject) {
    return {
      'years': years,
      'months': months,
      'day': days,
      'hour': hours,
      'minute': minutes,
    };
  }

  String timeRemaining = '';
  if (years > 0) timeRemaining += '${years}y:';
  if (months > 0) timeRemaining += '${months}m:';
  if (days > 0) timeRemaining += '${days}d:';
  if (hours > 0) timeRemaining += '${hours}h:';
  if (minutes > 0) timeRemaining += '${minutes}m';

  // Remove trailing colon
  if (timeRemaining.endsWith(':')) {
    timeRemaining = timeRemaining.substring(0, timeRemaining.length - 1);
  }

  return timeRemaining.isEmpty ? '0m' : timeRemaining;
}

// Calculate percentage of time used
double usingPercentage(dynamic begin, dynamic expire) {
  final now = Moment.now();
  final beginDate = begin is DateTime ? Moment(begin) : Moment.parse(begin);
  final expireDate = expire is DateTime ? Moment(expire) : Moment.parse(expire);

  final total = expireDate.difference(beginDate).inMilliseconds;
  final remaining = expireDate.difference(now).inMilliseconds;

  return ((1 - remaining / total) * 100).roundToDouble();
}

// Get color class based on usage percentage
String getColorClass(dynamic begin, dynamic expire) {
  final percentage = usingPercentage(begin, expire);
  if (percentage >= 93) {
    return 'text-red-500';
  } else if (percentage >= 80) {
    return 'text-yellow-500';
  } else {
    return 'text-green-500';
  }
}

// Convert time components to duration object
Map<String, int> getTimes({int d = 0, int h = 0, int m = 0, int s = 0}) {
  final totalSeconds = h * 3600 + m * 60 + s;
  final days = (totalSeconds / (24 * 3600)).floor() + d;
  final remainingSeconds = totalSeconds % (24 * 3600);
  final hours = (remainingSeconds / 3600).floor();
  final remainingSecondsAfterHours = remainingSeconds % 3600;
  final minutes = (remainingSecondsAfterHours / 60).floor();
  final seconds = remainingSecondsAfterHours % 60;

  return {'days': days, 'hours': hours, 'minutes': minutes, 'seconds': seconds};
}

// Calculate expiration time from duration components
DateTime calcExpireTime({int d = 0, int h = 0, int m = 0, int s = 0}) {
  final times = getTimes(d: d, h: h, m: m, s: s);
  final currentTime = DateTime.now();

  return currentTime.add(
    Duration(
      days: times['days']!,
      hours: times['hours']!,
      minutes: times['minutes']!,
      seconds: times['seconds']!,
    ),
  );
}
