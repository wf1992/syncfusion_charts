part of core;

//// Calculate the previous month start date.
DateTime getPreviousMonthDate(DateTime date) {
  return date.month == 1
      ? DateTime(date.year - 1, 12, 1)
      : DateTime(date.year, date.month - 1, 1);
}

//// Calculate the next month start date.
DateTime getNextMonthDate(DateTime date) {
  return date.month == 12
      ? DateTime(date.year + 1, 1, 1)
      : DateTime(date.year, date.month + 1, 1);
}

//// Return the given date if the date in between first and last date
//// else return first date/last date when the date before of first date or after last date
DateTime getValidDate(DateTime minDate, DateTime maxDate, DateTime date) {
  if (date.isAfter(minDate)) {
    if (date.isBefore(maxDate)) {
      return date;
    } else {
      return maxDate;
    }
  } else {
    return minDate;
  }
}

//// Check the dates are equal or not.
bool isSameDate(DateTime date1, DateTime date2) {
  if (date2 == date1) {
    return true;
  }

  if (date1 == null || date2 == null) {
    return false;
  }

  return date1.month == date2.month &&
      date1.year == date2.year &&
      date1.day == date2.day;
}

//// Check the date in between first and last date
bool isDateWithInDateRange(
    DateTime startDate, DateTime endDate, DateTime date) {
  if (startDate == null || endDate == null || date == null) {
    return false;
  }

  if (startDate.isAfter(endDate)) {
    final DateTime temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  if (isSameOrBeforeDate(endDate, date) && isSameOrAfterDate(startDate, date)) {
    return true;
  }

  return false;
}

//// Check the date before/same of last date
bool isSameOrBeforeDate(DateTime lastDate, DateTime date) {
  return isSameDate(lastDate, date) || lastDate.isAfter(date);
}

//// Check the date after/same of first date
bool isSameOrAfterDate(DateTime firstDate, DateTime date) {
  return isSameDate(firstDate, date) || firstDate.isBefore(date);
}

//// Get the visible dates based on the date value and visible dates count.
List<DateTime> getVisibleDates(DateTime date, List<int> nonWorkingDays,
    int firstDayOfWeek, int visibleDatesCount) {
  final List<DateTime> datesCollection = <DateTime>[];
  DateTime currentDate = date;
  if (firstDayOfWeek != null) {
    currentDate =
        getFirstDayOfWeekDate(visibleDatesCount, date, firstDayOfWeek);
  }

  for (int i = 0; i < visibleDatesCount; i++) {
    final DateTime visibleDate = currentDate.add(Duration(days: i));
    if (nonWorkingDays != null &&
        nonWorkingDays.contains(visibleDate.weekday)) {
      continue;
    }

    datesCollection.add(visibleDate);
  }

  return datesCollection;
}

//// Calculate first day of week date value based original date with first day of week value.
DateTime getFirstDayOfWeekDate(
    int visibleDatesCount, DateTime date, int firstDayOfWeek) {
  if (visibleDatesCount % 7 != 0) {
    return date;
  }

  const int numberOfWeekDays = 7;
  DateTime currentDate = date;
  if (visibleDatesCount == 42) {
    currentDate = DateTime(currentDate.year, currentDate.month, 1);
  }

  int value = -currentDate.weekday + firstDayOfWeek - numberOfWeekDays;
  if (value.abs() >= numberOfWeekDays) {
    value += numberOfWeekDays;
  }

  currentDate = currentDate.add(Duration(days: value));
  return currentDate;
}
