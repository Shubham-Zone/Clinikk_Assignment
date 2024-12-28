import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/Provider/theme_provider.dart';
import '../Models/task_model.dart';
import '../Provider/task_provider.dart';

class AddTaskForm extends StatefulWidget {
  final Task? initialTask;
  final int? index;

  const AddTaskForm({super.key, this.initialTask, this.index});

  @override
  AddTaskFormState createState() => AddTaskFormState();
}

class AddTaskFormState extends State<AddTaskForm> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? titleError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    // ... Initializing text controllers
    titleController =
        TextEditingController(text: widget.initialTask?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.initialTask?.description ?? '');
  }

  @override
  void dispose() {
    // ... Disposing text controllers
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTask(TaskProvider taskProvider) async {
    // Getting title and description
    final String title = titleController.text;
    final String description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      setState(() {
        titleError = title.isEmpty ? 'Please enter a title' : null;
        descriptionError =
            description.isEmpty ? 'Please enter a description' : null;
      });
      return;
    }

    // Creating a new task
    final Task task = Task(title: title, description: description);
    // Adding or updating task
    if (widget.index == null) {
      taskProvider.addTask(task);
    } else {
      taskProvider.updateTask(widget.index!, task);
    }

    showToast(
        widget.index == null
            ? 'Task added successfully'
            : 'Task updated successfully',
        context: context,
        backgroundColor: Colors.green,
        textStyle: const TextStyle(color: Colors.white),
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask == null ? "Add Task" : 'Update Task'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // task title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    errorText: titleError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // task description
                TextField(
                  minLines: 2,
                  maxLines: 5,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Task Description',
                    errorText: descriptionError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // add task
                ElevatedButton(
                  onPressed: () {
                    addTask(taskProvider);
                  },
                  child: Text(
                      widget.initialTask == null ? "Add Task" : 'Update Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
