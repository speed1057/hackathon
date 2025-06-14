import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class CreateEventPage extends HookConsumerWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final eventNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final isLoading = useState(false);

    Future<void> selectStartDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: startDate.value ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null && context.mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          startDate.value = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        }
      }
    }

    Future<void> selectEndDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: endDate.value ?? startDate.value ?? DateTime.now(),
        firstDate: startDate.value ?? DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null && context.mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          endDate.value = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        }
      }
    }

    void createEvent() async {
      if (formKey.currentState!.validate()) {
        if (startDate.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a start date')),
          );
          return;
        }
        if (endDate.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an end date')),
          );
          return;
        }
        if (endDate.value!.isBefore(startDate.value!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End date must be after start date')),
          );
          return;
        }

        isLoading.value = true;

        try {
          final event = Event(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: eventNameController.text.trim(),
            description: descriptionController.text.trim(),
            startDate: startDate.value!,
            endDate: endDate.value!,
            createdAt: DateTime.now(),
          );

          ref.read(eventsProvider.notifier).addEvent(event);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear form
          eventNameController.clear();
          descriptionController.clear();
          startDate.value = null;
          endDate.value = null;

          // Navigate back to home
          context.go('/');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating event: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  'Create a New Hackathon Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Event Name Field
                TextFormField(
                  controller: eventNameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                    hintText: 'Enter hackathon name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an event name';
                    }
                    if (value.trim().length < 3) {
                      return 'Event name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Describe your hackathon event',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an event description';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Start Date Field
                InkWell(
                  onTap: selectStartDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date & Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate.value != null
                              ? '${startDate.value!.day}/${startDate.value!.month}/${startDate.value!.year} ${startDate.value!.hour.toString().padLeft(2, '0')}:${startDate.value!.minute.toString().padLeft(2, '0')}'
                              : 'Select start date & time',
                          style: TextStyle(
                            color: startDate.value != null
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // End Date Field
                InkWell(
                  onTap: selectEndDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Date & Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_available),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endDate.value != null
                              ? '${endDate.value!.day}/${endDate.value!.month}/${endDate.value!.year} ${endDate.value!.hour.toString().padLeft(2, '0')}:${endDate.value!.minute.toString().padLeft(2, '0')}'
                              : 'Select end date & time',
                          style: TextStyle(
                            color: endDate.value != null
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Create Event Button
                ElevatedButton(
                  onPressed: isLoading.value ? null : createEvent,
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
                          'Create Event',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
