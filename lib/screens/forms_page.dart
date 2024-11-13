// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class FormsPage extends StatefulWidget {
//   const FormsPage({super.key});

//   @override
//   _FormsPageState createState() => _FormsPageState();
// }

// class _FormsPageState extends State<FormsPage> {
//   List<dynamic> _forms = [];
//   bool _isLoading = true;
//   dynamic _selectedForm; // Track the selected form
//   double _dividerPosition =
//       240.0; // Initial position of the divider (left panel width)
//   final double _thumbnailSize = 120.0; // Fixed size for each thumbnail

//   @override
//   void initState() {
//     super.initState();
//     _fetchForms();
//   }

//   Future<void> _fetchForms() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://localhost:5000/api/forms'));

//       if (response.statusCode == 200) {
//         setState(() {
//           _forms = jsonDecode(response.body);
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load forms');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching forms: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Uploaded Forms')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Row(
//               children: [
//                 // Left Section: Thumbnail grid with fixed thumbnail size
//                 Container(
//                   width: _dividerPosition,
//                   color: Colors.grey[100],
//                   child: _forms.isEmpty
//                       ? const Center(child: Text('No forms uploaded yet.'))
//                       : GridView.builder(
//                           padding: const EdgeInsets.all(8),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount:
//                                 (_dividerPosition / _thumbnailSize).floor(),
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                             childAspectRatio: 1,
//                           ),
//                           itemCount: _forms.length,
//                           itemBuilder: (context, index) {
//                             final form = _forms[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedForm = form;
//                                 });
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 elevation: 5,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: const BorderRadius.vertical(
//                                           top: Radius.circular(8)),
//                                       child: AspectRatio(
//                                         aspectRatio: 1,
//                                         child: Image.network(
//                                           'http://localhost:5000${form['images'][0]}', // First image in form images array
//                                           fit: BoxFit.contain,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(Icons.broken_image,
//                                                       size: 40),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),

//                 // Middle Resizable Divider
//                 GestureDetector(
//                   onHorizontalDragUpdate: (details) {
//                     setState(() {
//                       _dividerPosition += details.primaryDelta!;
//                       _dividerPosition = _dividerPosition.clamp(150.0, 400.0);
//                     });
//                   },
//                   child: MouseRegion(
//                     cursor: SystemMouseCursors.resizeColumn,
//                     child: Container(
//                       width: 12,
//                       color: Colors.grey[300],
//                       child: const Icon(
//                         Icons.drag_indicator,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Right Section: Selected form image (resizable)
//                 Expanded(
//                   child: _selectedForm == null
//                       ? const Center(
//                           child: Text('Select a form to view image'),
//                         )
//                       : Container(
//                           padding: const EdgeInsets.all(16),
//                           color: Colors.white,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Toolbar for image options
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.download),
//                                     tooltip: 'Download Image',
//                                     onPressed: () {
//                                       // Add functionality to download the image
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.zoom_in),
//                                     tooltip: 'Zoom In',
//                                     onPressed: () {
//                                       // Add functionality to zoom in
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete),
//                                     tooltip: 'Delete',
//                                     onPressed: () {
//                                       // Add functionality to delete the form
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               // Center the image in the right panel
//                               Expanded(
//                                 child: ListView(
//                                   children: _selectedForm['images']
//                                       .map<Widget>((imageUrl) {
//                                     return Center(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           'http://localhost:5000$imageUrl',
//                                           fit: BoxFit.contain,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(Icons.broken_image,
//                                                       size: 100),
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// forms_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_app/components/form_viewer.dart';
import 'package:new_app/components/thumbnail_grid.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  _FormsPageState createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  List<dynamic> _forms = [];
  bool _isLoading = true;
  dynamic _selectedForm;
  double _dividerPosition = 240.0;

  @override
  void initState() {
    super.initState();
    _fetchForms();
  }

  Future<void> _fetchForms() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/api/forms'));
      if (response.statusCode == 200) {
        setState(() {
          _forms = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load forms');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching forms: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploaded Forms')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                ThumbnailGrid(
                  forms: _forms,
                  dividerPosition: _dividerPosition,
                  onFormSelected: (form) {
                    setState(() {
                      _selectedForm = form;
                    });
                  },
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dividerPosition += details.primaryDelta!;
                      _dividerPosition = _dividerPosition.clamp(150.0, 400.0);
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: Container(
                      width: 12,
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.drag_indicator, color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: FormViewer(selectedForm: _selectedForm),
                ),
              ],
            ),
    );
  }
}
