import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatBotPage(),
    );
  }
}

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  bool isOpen = false;
  List<Map<String, String>> messages = [
    {'role': 'assistant', 'content': '👋 Привет! Чем могу помочь вам сегодня?'}
  ];
  TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  
  final String apiKey = 'Ylu1oN31YzftJyvA5mMVSaxQY0Nu5bN9'; // Replace with your API key

  Future<void> sendMessage(String input) async {
    if (input.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': input});
      isLoading = true;
    });

    inputController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.mistralai.com/chat/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': 'mistral-large-latest',
          'messages': messages,
          'maxTokens': 150
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          setState(() {
            messages.add({
              'role': 'assistant',
              'content': data['choices'][0]['message']['content'] ?? 'Ошибка в ответе.'
            });
          });
        }
      } else {
        print('Error: ${response.body}');
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
          if (isOpen)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 400,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Чат с ИИ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => setState(() {
                              isOpen = false;
                            }),
                          )
                        ],
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length + (isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == messages.length) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('● ● ●',
                                      style: TextStyle(color: Colors.grey)),
                                ),
                              );
                            }
                            final message = messages[index];
                            return Align(
                              alignment: message['role'] == 'user'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(12),
                                constraints: BoxConstraints(maxWidth: 250),
                                decoration: BoxDecoration(
                                  color: message['role'] == 'user'
                                      ? Colors.blue[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  message['content'] ?? '',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: inputController,
                              decoration: InputDecoration(
                                hintText: 'Введите сообщение...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => sendMessage(inputController.text),
                            child: Text('Ввести'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () => setState(() {
                isOpen = true;
              }),
              child: Icon(Icons.chat),
            ),
          )
        ],
      ),
    );
  }
}
