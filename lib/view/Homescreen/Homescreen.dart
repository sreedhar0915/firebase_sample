// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_sample/controller/homescreen_controller.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final Stream<QuerySnapshot> _usersStream =
//       FirebaseFirestore.instance.collection('students').snapshots();
//   List<Map<String, String>> items = [];

//   void _showBottomSheet(BuildContext context, {int? index}) {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController subjectController = TextEditingController();

//     if (index != null) {
//       nameController.text = items[index]['name']!;
//       subjectController.text = items[index]['subject']!;
//     }

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: subjectController,
//                 decoration: InputDecoration(labelText: 'Subject'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (index == null) {
//                     // Adding new item
//                     setState(() {
//                       items.add({
//                         'name': nameController.text,
//                         'subject': subjectController.text,
//                       });
//                     });
//                   } else {
//                     // Updating existing item
//                     setState(() {
//                       items[index]['name'] = nameController.text;
//                       items[index]['subject'] = subjectController.text;
//                     });
//                   }
//                   Navigator.pop(context); // Close bottom sheet
//                 },
//                 child: Text(index == null ? 'Add Item' : 'Save Changes'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _deleteItem(int index) {
//     setState(() {
//       items.removeAt(index);
//     });
//   }

//   void _showDeleteConfirmation(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Item'),
//           content: Text('Are you sure you want to delete this item?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _deleteItem(index);
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("STUDENT's LIST"),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: StreamBuilder(
//         stream: _usersStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final studentlist = snapshot.data!.docs;
//                 return ListTile(
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                   title: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [
//                         // First Row: Name and Edit Button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               studentlist[index]['name']!,
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                             Spacer(),
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () =>
//                                   _showBottomSheet(context, index: index),
//                             ),
//                           ],
//                         ),
//                         Divider(),

//                         // Second Row: Subject and Delete Button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               studentlist[index]['subject']!,
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.grey),
//                             ),
//                             Spacer(),
//                             IconButton(
//                                 icon: Icon(Icons.delete),
//                                 onPressed: () {
//                                   HomescreenController.deletedata(
//                                       studentlist[index].id);
//                                 }),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () =>
//             _showBottomSheet(context), // Open bottom sheet to add new item
//         child: Icon(Icons.add),
//         tooltip: 'Add Item',
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/controller/homescreen_controller.dart';
import 'package:firebase_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> students = [];
  final Stream<QuerySnapshot> _studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  void _addOrEditStudent(
      {Map<String, String>? student, int? index, String? id}) {
    final nameController = TextEditingController(text: student?['name'] ?? '');

    final courseController =
        TextEditingController(text: student?['subject'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: IconButton(
                    onPressed: () {
                      context.read<HomescreenController>().picker();
                    },
                    icon: Icon(Icons.camera_alt_outlined)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: courseController,
                decoration: InputDecoration(labelText: 'subject'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newStudent = {
                    'name': nameController.text,
                    'subject': courseController.text,
                  };
                  if (index != null) {
                    HomescreenController.editdata(id: id!, data: newStudent);
                  } else {
                    HomescreenController.adddata(data: newStudent);
                  }
                  Navigator.of(ctx).pop();
                },
                child: Text(index == null ? 'Add Student' : 'Update Student'),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _deleteStudent(int index) {
  //   setState(() {
  //     students.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Manager')),
      body: StreamBuilder(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                final studentlist = snapshot.data!.docs;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Name: ${studentlist[index]["name"]}"),
                    subtitle:
                        Text('Subject: ${studentlist[index]["subject"] ?? ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _addOrEditStudent(
                                    student: {},
                                    index: index,
                                    id: studentlist[index].id);
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              HomescreenController.deletedata(
                                  studentlist[index].id);
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditStudent(),
        child: Icon(Icons.add),
      ),
    );
  }
}
