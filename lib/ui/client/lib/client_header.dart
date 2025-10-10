import 'package:flutter/material.dart';

class ClientHeader extends StatelessWidget {
  final String name;
  final String activity;
  final VoidCallback? onEdit;

  const ClientHeader({
    super.key,
    required this.name,
    required this.activity,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Builder(
              builder: (ctx) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 28,
                    color: Color.fromARGB(255, 46, 145, 216),
                  ),
                  onPressed: () {
                    Scaffold.of(ctx).openDrawer();
                  },
                );
              },
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color.fromARGB(255, 46, 145, 216),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.grey, size: 20),
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Actividad: $activity",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
