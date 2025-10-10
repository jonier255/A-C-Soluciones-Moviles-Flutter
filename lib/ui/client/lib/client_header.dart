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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 1, 157, 214),
            Color.fromARGB(255, 9, 152, 218),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Row(
        children: [
          Builder(
            builder: (ctx) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 28,
                  color: Colors.white,
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
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Color(0xFF2196F3)),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.white70, size: 20),
                      onPressed: onEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Actividad: $activity",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
