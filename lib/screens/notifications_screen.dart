import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maps_launcher/maps_launcher.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const String routeName =
      '/notifications'; // Define routeName

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Level 1':
        return Colors.yellow.shade300;
      case 'Level 2':
        return Colors.orange.shade300;
      case 'Level 3':
        return Colors.red.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFEFFDFE,
      ), // light pastel red
      appBar: AppBar(title: const Text('Active Cases')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('cases')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No active cases"),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data()
                      as Map<String, dynamic>;

              final lat =
                  (data['location'][0] as num).toDouble();
              final lng =
                  (data['location'][1] as num).toDouble();

              return Card(
                // GestureDetector removed from here
                elevation: 2,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: _getSeverityColor(data['severity']),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      data['message'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "Location: $lat, $lng\nScore: ${data['score']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          data['severity'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ), // Spacing between text and button
                        IconButton(
                          icon: const Icon(
                            Icons.open_in_new,
                          ), // Icon suggesting opening in another app
                          iconSize:
                              28.0, // Decently sized icon
                          tooltip: 'Open in maps',
                          onPressed: () {
                            MapsLauncher.launchCoordinates(
                              lat,
                              lng,
                            );
                            // IntentUtils.launchGoogleMaps(
                            //   latitude: lat,
                            //   longitude: lng,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
