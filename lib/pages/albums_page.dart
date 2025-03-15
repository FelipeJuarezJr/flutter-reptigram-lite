import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
// Add other necessary imports

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBinderDialog(context),
        child: const Icon(Icons.create_new_folder),
        backgroundColor: AppColors.lightSecondary,
      ),
      body: _buildBindersList(),
    );
  }

  void _showCreateBinderDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Binder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Binder Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            child: const Text('Create Binder'),
          ),
        ],
      ),
    );
  }

  Widget _buildBinderIcon() {
    return Container(
      color: AppColors.lightSecondary.withOpacity(0.1),
      child: Icon(
        Icons.folder,
        size: 64,
        color: AppColors.lightSecondary,
      ),
    );
  }

  Widget _buildBindersList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              // Navigate to binder page
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBinderIcon(),
                const SizedBox(height: 8),
                Text(
                  'Binder ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 4,
    );
  }
} 