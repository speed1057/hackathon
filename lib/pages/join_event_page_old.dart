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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an event code')),
        );
        return;
      }

      // Find event by ID (using ID as event code)
      final event = events.where((e) => e.id == eventCode).firstOrNull;

      if (event != null) {
        selectedEvent.value = event;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found event: ${event.name}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        selectedEvent.value = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event not found. Please check the event code.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void joinEvent() async {
      if (formKey.currentState!.validate()) {
        if (selectedEvent.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please search for a valid event first'),
            ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please add at least one team member'),
              ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Team name is already taken. Please choose a different name.',
                ),
                backgroundColor: Colors.red,
              ),
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
          ref.read(teamsProvider.notifier).addTeam(team);

          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Successfully joined "${selectedEvent.value!.name}" with team "${team.name}"!',
                ),
                backgroundColor: Colors.green,
              ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error joining event: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join a Hackathon Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Event Code Field
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: eventCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Event Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.code),
                          hintText: 'Enter event code to join',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an event code';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: searchEvent,
                      child: const Text('Search'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Event Info Card
                if (selectedEvent.value != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedEvent.value!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedEvent.value!.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Starts: ${selectedEvent.value!.startDate.day}/${selectedEvent.value!.startDate.month}/${selectedEvent.value!.startDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Ends: ${selectedEvent.value!.endDate.day}/${selectedEvent.value!.endDate.month}/${selectedEvent.value!.endDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Team Name Field
                TextFormField(
                  controller: teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                    hintText: 'Enter your team name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a team name';
                    }
                    if (value.trim().length < 2) {
                      return 'Team name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Team Members Field
                TextFormField(
                  controller: teamMembersController,
                  decoration: const InputDecoration(
                    labelText: 'Team Members',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                    hintText: 'Enter member names separated by commas',
                    helperText: 'Example: John Doe, Jane Smith, Mike Johnson',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter team member names';
                    }
                    final members = value
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

                // Join Event Button
                ElevatedButton(
                  onPressed: isLoading.value ? null : joinEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Join Event',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                TextButton(
                  onPressed: isLoading.value ? null : () => context.go('/'),
                  child: const Text('Cancel'),
                ),

                const SizedBox(height: 32),

                // Available Events Section
                if (events.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Available Events',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...events.map(
                    (event) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(event.name),
                        subtitle: Text('Code: ${event.id}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            eventCodeController.text = event.id;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Event code copied!'),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          eventCodeController.text = event.id;
                          searchEvent();
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
