import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatHistoryScreen extends StatefulWidget {
  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<types.TextMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedMessages = prefs.getStringList('chat_history');

    if (storedMessages != null) {
      setState(() {
        _messages = storedMessages
            .map((msg) => types.TextMessage.fromJson(jsonDecode(msg)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Chat History"),
        backgroundColor: Colors.grey[900],
      ),
      body: _messages.isEmpty
          ? Center(
              child: Text(
                "No chat history available",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    message.author.id == 'user' ? "You" : "Bot",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
