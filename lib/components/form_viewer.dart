// form_viewer.dart

import 'package:flutter/material.dart';

class FormViewer extends StatelessWidget {
  final dynamic selectedForm;

  const FormViewer({super.key, required this.selectedForm});

  @override
  Widget build(BuildContext context) {
    if (selectedForm == null) {
      return const Center(
        child: Text('Select a form to view image'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Download Image',
                onPressed: () {
                  // Add functionality to download the image
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                tooltip: 'Zoom In',
                onPressed: () {
                  // Add functionality to zoom in
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {
                  // Add functionality to delete the form
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: selectedForm['images'].map<Widget>((imageUrl) {
                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'http://localhost:5000$imageUrl',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
