import '../models/models.dart';

class EventService {
  static bool isEventActive(Event event) {
    final now = DateTime.now();
    return event.startDate.isBefore(now) && event.endDate.isAfter(now);
  }

  static bool isEventUpcoming(Event event) {
    final now = DateTime.now();
    return event.startDate.isAfter(now);
  }

  static bool isEventPast(Event event) {
    final now = DateTime.now();
    return event.endDate.isBefore(now);
  }

  static String getEventStatus(Event event) {
    if (isEventUpcoming(event)) return 'Upcoming';
    if (isEventActive(event)) return 'Active';
    if (isEventPast(event)) return 'Past';
    return 'Unknown';
  }

  static Duration getTimeUntilStart(Event event) {
    return event.startDate.difference(DateTime.now());
  }

  static Duration getTimeUntilEnd(Event event) {
    return event.endDate.difference(DateTime.now());
  }

  static bool validateEventDates(DateTime startDate, DateTime endDate) {
    return startDate.isBefore(endDate);
  }

  static List<Event> sortEventsByStartDate(
    List<Event> events, {
    bool ascending = true,
  }) {
    final sortedEvents = List<Event>.from(events);
    sortedEvents.sort((a, b) {
      return ascending
          ? a.startDate.compareTo(b.startDate)
          : b.startDate.compareTo(a.startDate);
    });
    return sortedEvents;
  }
}
