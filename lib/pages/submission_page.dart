import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class SubmissionPage extends HookConsumerWidget {
  const SubmissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final projectTitleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final githubLinkController = useTextEditingController();
    final selectedTeam = useState<Team?>(null);
    final isLoading = useState(false);

    // Get teams and submissions
    final teams = ref.watch(teamsProvider);
    final submissions = ref.watch(submissionsProvider);

    // Filter teams that haven't submitted yet
    final availableTeams = teams.where((team) {
      return !submissions.any((submission) => submission.teamId == team.id);
    }).toList();

    void submitProject() async {
      if (formKey.currentState!.validate()) {
        if (selectedTeam.value == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please select a team')));
          return;
        }

        isLoading.value = true;

        try {
          // Check if team has already submitted
          final hasSubmitted = ref.read(
            hasTeamSubmittedProvider(selectedTeam.value!.id),
          );

          if (hasSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This team has already submitted a project.'),
                backgroundColor: Colors.orange,
              ),
            );
            isLoading.value = false;
            return;
          }

          // Create new submission
          final submission = Submission(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            teamId: selectedTeam.value!.id,
            eventId: selectedTeam.value!.eventId,
            projectTitle: projectTitleController.text.trim(),
            githubLink: githubLinkController.text.trim(),
            description: descriptionController.text.trim(),
            submittedAt: DateTime.now(),
          );

          // Add submission to provider
          ref.read(submissionsProvider.notifier).addSubmission(submission);

          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Project "${submission.projectTitle}" submitted successfully for team "${selectedTeam.value!.name}"!',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Clear form
            projectTitleController.clear();
            descriptionController.clear();
            githubLinkController.clear();
            selectedTeam.value = null;

            // Navigate back to home
            context.go('/');
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error submitting project: $e'),
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
        title: const Text('Submit Project'),
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
                  'Submit Your Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Team Selection
                if (availableTeams.isNotEmpty) ...[
                  DropdownButtonFormField<Team>(
                    value: selectedTeam.value,
                    decoration: const InputDecoration(
                      labelText: 'Select Team',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.group),
                      hintText: 'Choose your team',
                    ),
                    items: availableTeams.map((team) {
                      // Get event name for context
                      final event = ref
                          .read(eventsProvider)
                          .where((e) => e.id == team.eventId)
                          .firstOrNull;
                      return DropdownMenuItem<Team>(
                        value: team,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              team.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (event != null)
                              Text(
                                'Event: ${event.name}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            Text(
                              'Members: ${team.members.join(', ')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Team? team) {
                      selectedTeam.value = team;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a team';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Teams Available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You need to join an event and create a team before submitting a project.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.go('/join-event'),
                            child: const Text('Join Event'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Project Title Field
                TextFormField(
                  controller: projectTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Project Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter your project title',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a project title';
                    }
                    if (value.trim().length < 3) {
                      return 'Project title must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // GitHub Link Field
                TextFormField(
                  controller: githubLinkController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub Repository URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.code),
                    hintText: 'https://github.com/username/repository',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a GitHub repository URL';
                    }
                    if (!value.contains('github.com')) {
                      return 'Please enter a valid GitHub URL';
                    }
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Short Description Field
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Short Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Briefly describe your project',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a project description';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    if (value.trim().length > 500) {
                      return 'Description must be less than 500 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: (isLoading.value || availableTeams.isEmpty)
                      ? null
                      : submitProject,
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
                          'Submit Project',
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

                // Submitted Projects Section
                if (submissions.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Recent Submissions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...submissions.take(3).map((submission) {
                    final team = teams
                        .where((t) => t.id == submission.teamId)
                        .firstOrNull;
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(submission.projectTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (team != null) Text('Team: ${team.name}'),
                            Text(
                              'Submitted: ${submission.submittedAt.day}/${submission.submittedAt.month}/${submission.submittedAt.year}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Opening: ${submission.githubLink}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
