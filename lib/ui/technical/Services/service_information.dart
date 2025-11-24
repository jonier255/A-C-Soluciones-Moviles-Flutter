import 'package:flutter/material.dart';



class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Determine the main theme color for the shadow/accents
    const Color cardShadowColor = Color.fromRGBO(0, 123, 255, 0.4); // Semi-transparent blue
    const Color accentBlue = Color(0xFF007BFF); // For button/text

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      body: Column(
        children: [
         
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + screenHeight * 0.012,
              left: screenWidth * 0.025,
              right: screenWidth * 0.037,
              bottom: screenHeight * 0.012,
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
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.037, vertical: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.012),
                    ),
                  ),
                  child: Text('Volver', style: TextStyle(fontSize: screenWidth * 0.035)),
                ),
                // Company Logo
               /** */
                Text(
                  'A&C LOGO', // Placeholder for the actual image
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: screenWidth * 0.04),
                ),
                // Image.asset('assets/logo.png', height: 30), // Actual logo line
              ],
            ),
          ),

          
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
            child: Text(
              'Informacion del servicio',
              style: TextStyle(
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.037),
                  boxShadow: const [
                    BoxShadow(
                      color: cardShadowColor,
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Service Icon
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.037),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB3E5FC), // Light blue background for the icon
                            borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          ),
                          // **Replace with your custom icon image**
                          child: Icon(
                            Icons.handyman,
                            size: screenWidth * 0.12,
                            color: accentBlue,
                          ),
                          
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // Main Service Summary
                      Text(
                        'Suministro, instalacion y mantenimiento a brazos hidraulicos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.018),
                      Divider(height: screenHeight * 0.001, thickness: 1, color: Colors.grey),
                      SizedBox(height: screenHeight * 0.03),

                      
                      Text(
                        'Informacion',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.018),

                      
                      _buildDetailRow(
                        label: 'Nombre servicio:',
                        value: 'Suministro, instalacion y mantenimiento a brazos hidraulicos',
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      
                      _buildDetailRow(
                        label: 'Descripcion:',
                        value: 'Mantenimiento e instalacion',
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      
                      _buildDetailRow(
                        label: 'Fecha de creacion:',
                        value: '30 de junio de 2025, 21:22',
                        isLast: true, // Apply bottom line
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025), // Spacer before bottom nav
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
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.038,
          ),
        ),
        SizedBox(height: screenHeight * 0.006),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
          ),
        ),
        SizedBox(height: screenHeight * 0.006),
       
        Container(
          height: screenHeight * 0.0012,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}