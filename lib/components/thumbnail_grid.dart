// thumbnail_grid.dart
import 'package:flutter/material.dart';

class ThumbnailGrid extends StatelessWidget {
  final List<dynamic> forms;
  final double dividerPosition;
  final Function(dynamic) onFormSelected;

  const ThumbnailGrid({
    super.key,
    required this.forms,
    required this.dividerPosition,
    required this.onFormSelected,
  });

  @override
  Widget build(BuildContext context) {
    const double thumbnailSize = 120.0;

    return Container(
      width: dividerPosition,
      color: Colors.grey[100],
      child: forms.isEmpty
          ? const Center(child: Text('No forms uploaded yet.'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (dividerPosition / thumbnailSize).floor(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8, // Adjusted aspect ratio for more height
              ),
              itemCount: forms.length,
              itemBuilder: (context, index) {
                final form = forms[index];
                return GestureDetector(
                  onTap: () => onFormSelected(form),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          // Expanded for the image to use available space
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.network(
                              'http://localhost:5000${form['images'][0]}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                        ),
                        // Title section with ConstrainedBox
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 40, // Set minimum height for the title
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              form['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Center-align title
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
