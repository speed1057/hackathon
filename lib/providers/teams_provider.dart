import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

// Teams management
class TeamsNotifier extends StateNotifier<List<Team>> {
  TeamsNotifier() : super([]);

  // Initialize and load data
  Future<void> initialize() async {
    final teams = await DataPersistenceService.loadTeams();
    state = teams;
  }

  Future<void> addTeam(Team team) async {
    state = [...state, team];
    await DataPersistenceService.saveTeams(state);
  }

  Future<void> removeTeam(String teamId) async {
    state = state.where((team) => team.id != teamId).toList();
    await DataPersistenceService.saveTeams(state);
  }

  Future<void> updateTeam(Team updatedTeam) async {
    state = state.map((team) {
      if (team.id == updatedTeam.id) {
        return updatedTeam;
      }
      return team;
    }).toList();
    await DataPersistenceService.saveTeams(state);
  }

  Future<void> clearTeams() async {
    state = [];
    await DataPersistenceService.saveTeams(state);
  }

  Team? getTeamById(String teamId) {
    try {
      return state.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }

  List<Team> getTeamsByEventId(String eventId) {
    return state.where((team) => team.eventId == eventId).toList();
  }

  bool isTeamNameTaken(String eventId, String teamName) {
    return state.any(
      (team) =>
          team.eventId == eventId &&
          team.name.toLowerCase() == teamName.toLowerCase(),
    );
  }
}

// Provider for managing teams
final teamsProvider = StateNotifierProvider<TeamsNotifier, List<Team>>((ref) {
  return TeamsNotifier();
});

// Provider for getting teams by event ID
final teamsByEventProvider = Provider.family<List<Team>, String>((
  ref,
  eventId,
) {
  final teams = ref.watch(teamsProvider);
  return teams.where((team) => team.eventId == eventId).toList();
});

// Provider for checking if team name is taken in an event
final isTeamNameTakenProvider =
    Provider.family<bool, ({String eventId, String teamName})>((ref, params) {
      final teams = ref.watch(teamsProvider);
      return teams.any(
        (team) =>
            team.eventId == params.eventId &&
            team.name.toLowerCase() == params.teamName.toLowerCase(),
      );
    });
