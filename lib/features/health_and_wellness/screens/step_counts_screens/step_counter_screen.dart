import 'package:flutter/material.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  bool _isMenuExpanded = false;
  bool isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar with Today and Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMenuExpanded = !_isMenuExpanded;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            _isMenuExpanded
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  const _StepCard(),
                  const SizedBox(height: AppConstants.spacing16),
                  Text("Daily average: 0"),
                  const _WeekProgress(),
                  const SizedBox(height: AppConstants.spacing16),
                  const _WaterTrackerCard(),
                ],
              ),
            ),
          ),

          // Expandable Menu controlled by top arrow only
          if (_isMenuExpanded)
            Positioned(
              right: 16,
              top: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildFab(Icons.emoji_events, "Achievements"),
                  _buildFab(Icons.history, "History"),
                  _buildFab(Icons.delete, "Reset"),
                  _buildFab(Icons.power_settings_new, "Turn off", isRed: true),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildFab(IconData icon, String label, {bool isRed = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          heroTag: label,
          backgroundColor: isRed ? Colors.red : Colors.green,
          mini: true,
          onPressed: () {
            // Add your action logic here
          },
          child: Icon(icon, color: Colors.white),
        ),
      ],
    ),
  );
}

class _StepCard extends StatefulWidget {
  const _StepCard({super.key});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  int _stepGoal = 6000;
  int _currentSteps = 0;

  void _editGoal() async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) => const _EditStepGoalDialog(initialGoal: 0),
    );
    if (result != null) {
      setState(() {
        _currentSteps = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Step count and editable goal
              Row(
                children: [
                  Text(
                    _currentSteps.toString(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _editGoal,
                    child: Row(
                      children: [
                        Text(
                          '/$_stepGoal Step',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.edit, size: 16, color: Colors.white70),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.pause_circle_filled,
                color: Colors.white,
                size: 36,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacing16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.spacing8),
            child: const LinearProgressIndicator(
              value: 0.0,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: AppConstants.spacing16),

          // Stats
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(icon: Icons.map_outlined, value: '0.0', label: 'Km'),
              _StatItem(
                icon: Icons.local_fire_department,
                value: '0.0',
                label: 'Calories',
              ),
              _StatItem(icon: Icons.access_time, value: '0h 0m', label: 'Time'),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditStepGoalDialog extends StatefulWidget {
  final int initialGoal;

  const _EditStepGoalDialog({required this.initialGoal});

  @override
  State<_EditStepGoalDialog> createState() => _EditStepGoalDialogState();
}

class _EditStepGoalDialogState extends State<_EditStepGoalDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialGoal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Step Goal"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Step Goal'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(_controller.text);
            if (newGoal != null && newGoal > 0) {
              Navigator.pop(context, newGoal);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: Colors.yellowAccent),
        const SizedBox(height: AppConstants.spacing4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _WeekProgress extends StatelessWidget {
  const _WeekProgress({super.key});

  final List<String> days = const ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            days
                .map(
                  (day) => CircleAvatar(
                    backgroundColor:
                        Colors.white24, // slightly visible contrast
                    radius: 18,
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _WaterTrackerCard extends StatelessWidget {
  const _WaterTrackerCard({super.key});

  Widget _waterGlass({bool plus = false}) {
    return Column(
      children: [
        Icon(
          plus ? Icons.add : Icons.local_drink,
          size: 30,
          color: Colors.white,
        ),
        const SizedBox(height: 4),
        const Text("200 ml", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Water header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Water: 0 / 500 ml", style: TextStyle(color: Colors.white)),
              Text("More", style: TextStyle(color: Colors.greenAccent)),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),

          // Glasses row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_waterGlass(plus: true), _waterGlass(), _waterGlass()],
          ),
        ],
      ),
    );
  }
}
