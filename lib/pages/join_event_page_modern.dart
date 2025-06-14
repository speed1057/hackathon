import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class JoinEventPage extends HookConsumerWidget {
  const JoinEventPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final eventCodeController = useTextEditingController();
    final teamNameController = useTextEditingController();
    final teamMembersController = useTextEditingController();
    final isLoading = useState(false);
    final selectedEvent = useState<Event?>(null);

    // Get events to validate event code
    final events = ref.watch(eventsProvider);

    void searchEvent() {
      final eventCode = eventCodeController.text.trim();
      if (eventCode.isEmpty) {
        _showSnackBar(context, 'Please enter an event code', isError: true);
        return;
      }

      // Find event by ID (using ID as event code)
      final event = events.where((e) => e.id == eventCode).firstOrNull;

      if (event != null) {
        selectedEvent.value = event;
        _showSnackBar(context, 'Found event: ${event.name}', isError: false);
      } else {
        selectedEvent.value = null;
        _showSnackBar(
          context,
          'Event not found. Please check the event code.',
          isError: true,
        );
      }
    }

    Future<void> joinEvent() async {
      if (!formKey.currentState!.validate()) return;

      if (selectedEvent.value == null) {
        _showSnackBar(
          context,
          'Please search for a valid event first',
          isError: true,
        );
        return;
      }

      isLoading.value = true;

      try {
        // Parse team members from comma-separated string
        final membersInput = teamMembersController.text.trim();
        final members = membersInput
            .split(',')
            .map((member) => member.trim())
            .where((member) => member.isNotEmpty)
            .toList();

        if (members.isEmpty) {
          _showSnackBar(
            context,
            'Please add at least one team member',
            isError: true,
          );
          isLoading.value = false;
          return;
        }

        // Check if team name is already taken
        final isNameTaken = ref.read(
          isTeamNameTakenProvider((
            eventId: selectedEvent.value!.id,
            teamName: teamNameController.text.trim(),
          )),
        );

        if (isNameTaken) {
          _showSnackBar(
            context,
            'Team name is already taken. Please choose a different name.',
            isError: true,
          );
          isLoading.value = false;
          return;
        }

        // Create new team
        final team = Team(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          eventId: selectedEvent.value!.id,
          name: teamNameController.text.trim(),
          members: members,
          createdAt: DateTime.now(),
        );

        // Add team to provider
        await ref.read(teamsProvider.notifier).addTeam(team);

        if (context.mounted) {
          _showSnackBar(
            context,
            'Successfully joined "${selectedEvent.value!.name}" with team "${team.name}"!',
            isError: false,
          );

          // Clear form
          eventCodeController.clear();
          teamNameController.clear();
          teamMembersController.clear();
          selectedEvent.value = null;

          // Navigate back to home
          context.go('/');
        }
      } catch (e) {
        if (context.mounted) {
          _showSnackBar(context, 'Error joining event: $e', isError: true);
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar.large(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Join Event',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go('/'),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.group_add_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Join a Hackathon',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Enter event code and create your team',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Form Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Event Code Field with Search
                          _buildEventCodeField(
                            context,
                            eventCodeController,
                            searchEvent,
                          ),
                          const SizedBox(height: 24),

                          // Selected Event Info
                          if (selectedEvent.value != null) ...[
                            _buildEventInfoCard(context, selectedEvent.value!),
                            const SizedBox(height: 24),
                          ],

                          // Team Name Field
                          _buildFormField(
                            context,
                            'Team Name',
                            'Enter your team name',
                            Icons.group_rounded,
                            teamNameController,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Please enter a team name';
                              }
                              if (value!.trim().length < 2) {
                                return 'Team name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Team Members Field
                          _buildFormField(
                            context,
                            'Team Members',
                            'Enter member names separated by commas\\nExample: John Doe, Jane Smith, Mike Johnson',
                            Icons.people_rounded,
                            teamMembersController,
                            maxLines: 3,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Please enter team member names';
                              }
                              final members = value!
                                  .split(',')
                                  .map((member) => member.trim())
                                  .where((member) => member.isNotEmpty)
                                  .toList();
                              if (members.isEmpty) {
                                return 'Please add at least one team member';
                              }
                              if (members.length > 6) {
                                return 'Maximum 6 team members allowed';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Join Button
                          FilledButton.icon(
                            onPressed: isLoading.value ? null : joinEvent,
                            icon: isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.rocket_launch_rounded),
                            label: Text(
                              isLoading.value ? 'Joining...' : 'Join Event',
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Available Events Section
                if (events.isNotEmpty)
                  _buildAvailableEventsSection(
                    context,
                    events,
                    eventCodeController,
                    searchEvent,
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCodeField(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onSearch,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Code',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter event code to join',
                  prefixIcon: const Icon(Icons.qr_code_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Please enter an event code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded),
              label: const Text('Search'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventInfoCard(BuildContext context, Event event) {
    final now = DateTime.now();
    final isActive =
        now.isAfter(event.startDate) && now.isBefore(event.endDate);
    final isUpcoming = now.isBefore(event.startDate);

    Color statusColor = isActive
        ? Colors.green
        : isUpcoming
        ? Colors.orange
        : Colors.grey;
    String statusText = isActive
        ? 'LIVE'
        : isUpcoming
        ? 'UPCOMING'
        : 'ENDED';

    return Card(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.verified_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  '${event.startDate.day}/${event.startDate.month}/${event.startDate.year} - ${event.endDate.day}/${event.endDate.month}/${event.endDate.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context,
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableEventsSection(
    BuildContext context,
    List<Event> events,
    TextEditingController eventCodeController,
    VoidCallback searchEvent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.event_available_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Available Events',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...events.map(
          (event) => _buildEventListItem(
            context,
            event,
            eventCodeController,
            searchEvent,
          ),
        ),
      ],
    );
  }

  Widget _buildEventListItem(
    BuildContext context,
    Event event,
    TextEditingController eventCodeController,
    VoidCallback searchEvent,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          eventCodeController.text = event.id;
          searchEvent();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${event.id}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  eventCodeController.text = event.id;
                  _showSnackBar(context, 'Event code copied!', isError: false);
                },
                icon: const Icon(Icons.copy_rounded),
                tooltip: 'Copy event code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
