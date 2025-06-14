import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'pages/home_page.dart';
import 'pages/create_event_page.dart';
import 'pages/join_event_page.dart';
import 'pages/submission_page.dart';
import 'pages/judge_page.dart';
import 'pages/team_chat_page.dart';
import 'providers/providers.dart';
import 'services/services.dart';

void main() {
  // Initialize white label service
  WhiteLabelService.getCurrentConfig();
  WhiteLabelService.updateBrowserTitle();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/create-event',
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: '/join-event',
        builder: (context, state) => const JoinEventPage(),
      ),
      GoRoute(
        path: '/submission',
        builder: (context, state) => const SubmissionPage(),
      ),
      GoRoute(path: '/judge', builder: (context, state) => const JudgePage()),
      GoRoute(
        path: '/team-chat/:teamId',
        builder: (context, state) {
          final teamId = state.pathParameters['teamId']!;
          return TeamChatPage(teamId: teamId);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whiteLabelConfig = ref.watch(whiteLabelConfigProvider);
    final appInitialization = ref.watch(appInitializationProvider);

    return MaterialApp.router(
      title: whiteLabelConfig.appTitle,
      theme: whiteLabelConfig.createThemeData(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return appInitialization.when(
          data: (_) => child ?? const SizedBox.shrink(),
          loading: () => const AppLoadingScreen(),
          error: (error, _) => AppErrorScreen(error: error),
        );
      },
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            stops: const [0.3, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern loading animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Hackathon Manager',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Loading your workspace...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              // Modern progress indicator
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorScreen extends StatelessWidget {
  final Object error;

  const AppErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // You could add retry logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade600,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
