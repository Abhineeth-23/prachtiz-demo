import 'package:flutter/material.dart';
import '../../models/kanban_task.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class TaskBoardScreen extends StatefulWidget {
  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  final List<KanbanTask> _tasks = [
    KanbanTask(id: "TSK-01", title: "Sterilize cardiology tools", description: "Ensure surgical room 2 is fully prepped for afternoon procedure.", assignee: "Nurse Emily", status: TaskStatus.todo, priority: TaskPriority.high),
    KanbanTask(id: "TSK-02", title: "Sign medical certificates", description: "Batch of 5 patient certificates waiting signature authorization.", assignee: "Dr. Sarah", status: TaskStatus.inProgress, priority: TaskPriority.medium),
    KanbanTask(id: "TSK-03", title: "Upload biochemical lab panels", description: "PT-0482 blood panel reports arrived, compile for EMR entry.", assignee: "Nurse Emily", status: TaskStatus.review, priority: TaskPriority.high),
    KanbanTask(id: "TSK-04", title: "Restock vaccine inventory", description: "200 doses of Pfizer COVID boosters added to temperature fridge.", assignee: "Nurse John", status: TaskStatus.done, priority: TaskPriority.low),
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Administrative Task Board", style: AppStyles.titleMedium),
        Text("Kanban workflows to coordinate clinician schedules and room preps", style: AppStyles.bodySmall),
        const SizedBox(height: 16),

        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            if (isMobile) {
              return ListView(
                children: [
                  _buildKanbanColumn("TO DO", TaskStatus.todo),
                  const SizedBox(height: 16),
                  _buildKanbanColumn("IN PROGRESS", TaskStatus.inProgress),
                  const SizedBox(height: 16),
                  _buildKanbanColumn("UNDER REVIEW", TaskStatus.review),
                  const SizedBox(height: 16),
                  _buildKanbanColumn("COMPLETED", TaskStatus.done),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildKanbanColumn("TO DO", TaskStatus.todo)),
                const SizedBox(width: 8),
                Expanded(child: _buildKanbanColumn("IN PROGRESS", TaskStatus.inProgress)),
                const SizedBox(width: 8),
                Expanded(child: _buildKanbanColumn("UNDER REVIEW", TaskStatus.review)),
                const SizedBox(width: 8),
                Expanded(child: _buildKanbanColumn("COMPLETED", TaskStatus.done)),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildKanbanColumn(String columnName, TaskStatus status) {
    List<KanbanTask> columnTasks = _tasks.where((t) => t.status == status).toList();
    Color columnColor = _getColumnColor(status);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.gray50.withOpacity(0.8),
        borderRadius: AppStyles.radiusMd,
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                columnName,
                style: AppStyles.caption.copyWith(color: columnColor, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: columnColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "${columnTasks.length}",
                  style: TextStyle(color: columnColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: columnTasks.length,
              itemBuilder: (context, index) {
                final task = columnTasks[index];
                return _buildTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(KanbanTask task) {
    Color priorityColor = _getPriorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: AppStyles.cardDecoration(borderRadius: AppStyles.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: priorityColor.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(color: priorityColor, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(task.id, style: const TextStyle(fontSize: 9, color: AppColors.gray400, fontFamily: 'monospace')),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.title, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(task.description, style: AppStyles.bodySmall.copyWith(fontSize: 10)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 14, color: AppColors.gray400),
                    const SizedBox(width: 4),
                    Text(task.assignee, style: AppStyles.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Shifter controls
                Row(
                  children: [
                    if (task.status != TaskStatus.todo)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 14, color: AppColors.gray500),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _shiftTask(task, false),
                      ),
                    if (task.status != TaskStatus.done)
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 14, color: AppColors.gray500),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _shiftTask(task, true),
                      ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _shiftTask(KanbanTask task, bool forward) {
    setState(() {
      int idx = _tasks.indexOf(task);
      TaskStatus newStatus;
      if (forward) {
        if (task.status == TaskStatus.todo) newStatus = TaskStatus.inProgress;
        else if (task.status == TaskStatus.inProgress) newStatus = TaskStatus.review;
        else newStatus = TaskStatus.done;
      } else {
        if (task.status == TaskStatus.done) newStatus = TaskStatus.review;
        else if (task.status == TaskStatus.review) newStatus = TaskStatus.inProgress;
        else newStatus = TaskStatus.todo;
      }
      _tasks[idx] = task.copyWith(status: newStatus);
    });
  }

  Color _getColumnColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.accentBlue;
      case TaskStatus.inProgress:
        return AppColors.accentOrange;
      case TaskStatus.review:
        return AppColors.accentPurple;
      case TaskStatus.done:
        return AppColors.accentGreen;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.accentGreen;
      case TaskPriority.medium:
        return AppColors.accentOrange;
      case TaskPriority.high:
        return AppColors.accentRed;
    }
  }
}
