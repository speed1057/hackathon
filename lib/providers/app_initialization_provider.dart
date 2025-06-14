import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/services.dart';
import 'providers.dart';

// App initialization provider
class AppInitializationNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  AppInitializationNotifier(this.ref) : super(const AsyncValue.loading()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      // Initialize data persistence service
      await DataPersistenceService.init();

      // Initialize sample data if first run
      await DataPersistenceService.initializeSampleData();

      // Load data into providers
      await ref.read(eventsProvider.notifier).initialize();
      await ref.read(teamsProvider.notifier).initialize();
      await ref.read(submissionsProvider.notifier).initialize();
      await ref.read(judgeScoresProvider.notifier).initialize();

      state = const AsyncValue.data(true);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resetData() async {
    try {
      state = const AsyncValue.loading();

      // Clear all data
      await DataPersistenceService.clearAllData();

      // Reinitialize
      await initialize();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final appInitializationProvider =
    StateNotifierProvider<AppInitializationNotifier, AsyncValue<bool>>((ref) {
      return AppInitializationNotifier(ref);
    });

// Helper provider to check if app is initialized
final isAppInitializedProvider = Provider<bool>((ref) {
  final initState = ref.watch(appInitializationProvider);
  return initState.when(
    data: (isInitialized) => isInitialized,
    loading: () => false,
    error: (_, __) => false,
  );
});
