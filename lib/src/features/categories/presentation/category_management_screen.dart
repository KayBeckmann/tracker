import 'package:flutter/material.dart';
import 'package:tracker/src/core/database/database.dart';
import 'package:tracker/main.dart' as main;

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: StreamBuilder<List<Category>>(
        stream: main.database.select(main.database.categories).watch(),
        builder: (context, snapshot) {
          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories yet.'),
            );
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                // TODO: Add edit/delete functionality
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _categoryNameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _categoryNameController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCategory();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addCategory() {
    if (_categoryNameController.text.isNotEmpty) {
      main.database.into(main.database.categories).insert(
            CategoriesCompanion.insert(
              name: _categoryNameController.text,
            ),
          );
      _categoryNameController.clear();
    }
  }
}
