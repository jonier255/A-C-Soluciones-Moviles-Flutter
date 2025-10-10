// import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
// import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

// import 'package:flutter/material.dart';

// class ChatsPage extends StatelessWidget {
//   const ChatsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerClient(),
//       body: const Column(
//         children: [
//           ClientHeader(
//             name: "Jonier Urrea",
//             activity: "70%",
//           ), // ✅ Solo lo llamas así
//           Expanded(
//             child: Center(
//               child: Text("💬 Chat con soporte"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"text": text, "isUser": true});
      // Simula respuesta automática del soporte
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _messages.add({
            "text": "Soporte: Gracias por tu mensaje. ¿En qué puedo ayudarte?",
            "isUser": false,
          });
          _scrollToBottom();
        });
      });
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      backgroundColor: Colors.blue.shade50, // 🔹 Fondo suave tipo chat
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Encabezado con nombre
            const ClientHeader(
              name: "Jonier Urrea",
              activity: "70%",
            ),

            // 🔹 Mensajes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message["isUser"] as bool;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUser ? Colors.blueAccent.shade100 : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser
                              ? const Radius.circular(16)
                              : const Radius.circular(0),
                          bottomRight: isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message["text"],
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 Caja de entrada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje...",
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Colors.lightBlueAccent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
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
