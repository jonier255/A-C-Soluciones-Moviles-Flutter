import 'package:flutter/material.dart';
import '../Drawer/drawerClient.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                            icon: const Icon(Icons.menu,
                                size: 28,
                                color: Color.fromARGB(255, 46, 145, 216)),
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
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Jonier Urrea",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.grey, size: 20),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Actividad: 70%",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Branding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Image.asset(
                    "assets/soluciones.png",
                    height: 250,
                    width: 250,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildImageCard("assets/servicio1.jpg", "Servicio 1"),
                    _buildImageCard("assets/servicio2.jpg", "Servicio 2"),
                    _buildImageCard("assets/servicio3.webp", "Servicio 3"),
                    _buildImageCard("assets/servicio4.jpg", "Servicio 4"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath, String title) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 16, right: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
