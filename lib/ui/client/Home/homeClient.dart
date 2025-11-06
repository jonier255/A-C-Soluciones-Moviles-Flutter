import 'package:flutter/material.dart';

class ClientHomeContent extends StatelessWidget {
  const ClientHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.90,
            padding: const EdgeInsets.all(32),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/bannercompany-removebg-preview.png",
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'A & C Soluciones',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Reparaciones y Mantenimientos',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 145, 103, 103)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.red[500]),
                          const SizedBox(width: 4),
                          const Text('41'),
                        ],
                      ),
                    ],
                  ),

                  // iconos de acciones
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[50],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.call, color: Colors.blue[400]),
                        Icon(Icons.shopping_cart, color: Colors.blue[400]),
                        Icon(Icons.message, color: Colors.blue[400]),
                        Icon(Icons.share, color: Colors.blue[400]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem",
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5, // espaciado entre líneas (opcional)
                      ),
                      textAlign: TextAlign.justify, // para justificar el texto
                    ),
                  ),
                ],
              ),
            )));
  }
}
