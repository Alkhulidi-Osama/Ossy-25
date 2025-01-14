import 'package:flutter/material.dart';
import 'package:my_portfolio/views/main_dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI-TRiSM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainDashBoardWithChatBot(),
    );
  }
}

class MainDashBoardWithChatBot extends StatefulWidget {
  const MainDashBoardWithChatBot({Key? key}) : super(key: key);

  @override
  _MainDashBoardWithChatBotState createState() => _MainDashBoardWithChatBotState();
}

class _MainDashBoardWithChatBotState extends State<MainDashBoardWithChatBot> {
  bool isOpen = false;
  final List<Map<String, String>> messages = [
    {'role': 'assistant', 'content': '👋 Привет! Чем могу помочь вам сегодня?'}
  ];
  final TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  
  final String apiKey = 'Ylu1oN31YzftJyvA5mMVSaxQY0Nu5bN9';

  Future<void> sendMessage(String input) async {
    if (input.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': input});
      isLoading = true;
    });

    inputController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.mistral.ai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': 'mistral-large-latest',
          'messages': messages,
          'max_tokens': 150  // Исправлено с maxTokens на max_tokens
        }),
      );

       if (response.statusCode == 200) {
        // Декодируем ответ с учетом UTF-8
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          final content = data['choices'][0]['message']['content'];
          setState(() {
            messages.add({
              'role': 'assistant',
              'content': content ?? 'Ошибка в ответе.'
            });
          });
        }
      } else {
        print('Error: ${response.statusCode}');
        // Декодируем тело ошибки с учетом UTF-8
        print('Response body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (error) {
      print('Error fetching chat response: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MainDashBoard(),
          if (isOpen)
            Positioned(
              bottom: 100,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 300,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Чат с ИИ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => setState(() => isOpen = false),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: messages.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == messages.length) {
                                return const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('● ● ●', 
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }
                              
                              final message = messages[index];
                              final isUser = message['role'] == 'user';
                              
                              return Align(
                                alignment: isUser 
                                  ? Alignment.centerRight 
                                  : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  constraints: const BoxConstraints(maxWidth: 250),
                                  decoration: BoxDecoration(
                                    color: isUser 
                                      ? Colors.blue[100] 
                                      : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message['content'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: inputController,
                                  decoration: InputDecoration(
                                    hintText: 'Введите сообщение...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => sendMessage(inputController.text),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Ввести'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => setState(() => isOpen = !isOpen),
              child: Icon(isOpen ? Icons.close : Icons.chat),
            ),
          ),
        ],
      ),
    );
  }
}