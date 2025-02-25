import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot');
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    _getBotResponse(message.text);
  }

  void _getBotResponse(String query) async {
    String response = await fetchResponseFromBackend(query);

    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: response,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  Future<String> fetchResponseFromBackend(String query) async {
    return "Sample response for: $query"; // Replace with actual API call
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          ChatScreenContent(messages: _messages, onSendPressed: _handleSendPressed, user: _user),
          Center(child: Text("Page 2", style: TextStyle(fontSize: 20))),
          Center(child: Text("Page 3", style: TextStyle(fontSize: 20))),
          Center(child: Text("Page 4", style: TextStyle(fontSize: 20))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class ChatScreenContent extends StatelessWidget {
  final List<types.Message> messages;
  final void Function(types.PartialText) onSendPressed;
  final types.User user;

  const ChatScreenContent({required this.messages, required this.onSendPressed, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot")),
      body: Chat(
        messages: messages,
        onSendPressed: onSendPressed,
        user: user,
      ),
    );
  }
}
