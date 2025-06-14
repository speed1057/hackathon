import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

// Events management
class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super([]);

  // Initialize and load data
  Future<void> initialize() async {
    final events = await DataPersistenceService.loadEvents();
    state = events;
  }

  Future<void> addEvent(Event event) async {
    state = [...state, event];
    await DataPersistenceService.saveEvents(state);
  }

  Future<void> removeEvent(String eventId) async {
    state = state.where((event) => event.id != eventId).toList();
    await DataPersistenceService.saveEvents(state);
  }

  Future<void> updateEvent(Event updatedEvent) async {
    state = state.map((event) {
      if (event.id == updatedEvent.id) {
        return updatedEvent;
      }
      return event;
    }).toList();
    await DataPersistenceService.saveEvents(state);
  }

  Future<void> clearEvents() async {
    state = [];
    await DataPersistenceService.saveEvents(state);
  }

  Event? getEventById(String eventId) {
    try {
      return state.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  List<Event> getUpcomingEvents() {
    final now = DateTime.now();
    return state.where((event) => event.startDate.isAfter(now)).toList();
  }

  List<Event> getActiveEvents() {
    final now = DateTime.now();
    return state
        .where(
          (event) =>
              event.startDate.isBefore(now) && event.endDate.isAfter(now),
        )
        .toList();
  }

  List<Event> getPastEvents() {
    final now = DateTime.now();
    return state.where((event) => event.endDate.isBefore(now)).toList();
  }
}

// Provider for managing events
final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((
  ref,
) {
  return EventsNotifier();
});

// Provider for getting upcoming events
final upcomingEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events.where((event) => event.startDate.isAfter(now)).toList();
});

// Provider for getting active events
final activeEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events
      .where(
        (event) => event.startDate.isBefore(now) && event.endDate.isAfter(now),
      )
      .toList();
});

// Provider for getting past events
final pastEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events.where((event) => event.endDate.isBefore(now)).toList();
});
