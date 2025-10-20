import 'package:flutter/material.dart';



class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the main theme color for the shadow/accents
    const Color cardShadowColor = Color.fromRGBO(0, 123, 255, 0.4); // Semi-transparent blue
    const Color accentBlue = Color(0xFF007BFF); // For button/text

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      body: Column(
        children: [
         
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              right: 15,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 'Volver' Button
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context); // Implement navigation back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text('Volver'),
                ),
                // Company Logo
               /** */
                const Text(
                  'A&C LOGO', // Placeholder for the actual image
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                // Image.asset('assets/logo.png', height: 30), // Actual logo line
              ],
            ),
          ),

          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Informacion del servicio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor,
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Service Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB3E5FC), // Light blue background for the icon
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // **Replace with your custom icon image**
                          child: const Icon(
                            Icons.handyman,
                            size: 50,
                            color: accentBlue,
                          ),
                          
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Main Service Summary
                      const Text(
                        'Suministro, instalacion y mantenimiento a brazos hidraulicos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(height: 1, thickness: 1, color: Colors.grey),
                      const SizedBox(height: 25),

                      
                      const Text(
                        'Informacion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      
                      _buildDetailRow(
                        label: 'Nombre servicio:',
                        value: 'Suministro, instalacion y mantenimiento a brazos hidraulicos',
                      ),
                      const SizedBox(height: 25),

                      
                      _buildDetailRow(
                        label: 'Descripcion:',
                        value: 'Mantenimiento e instalacion',
                      ),
                      const SizedBox(height: 25),

                      
                      _buildDetailRow(
                        label: 'Fecha de creacion:',
                        value: '30 de junio de 2025, 21:22',
                        isLast: true, // Apply bottom line
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Spacer before bottom nav
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: accentBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }

 
  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
       
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}