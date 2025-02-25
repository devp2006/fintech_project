import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:npci/his.dart';
import 'package:npci/pdf_page.dart';
import 'package:npci/profile.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding and decoding JSON

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

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = _messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList('chat_history', chatHistory);
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

      _saveChatHistory(); // Ensure data is properly stored
    }
  }

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

    _saveChatHistory(); // Save history after sending message
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

    _saveChatHistory(); // Save history after bot response
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
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          ChatScreenContent(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
          ),
          ChatHistoryScreen(),
          UploadPDFScreen(),
          ProfileHome(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: "PDF"),
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

  const ChatScreenContent({
    required this.messages,
    required this.onSendPressed,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 40,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Chatbot",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Chat(
          messages: messages,
          onSendPressed: onSendPressed,
          user: user,
          theme: DefaultChatTheme(
            backgroundColor: Colors.black,
            primaryColor: Color.fromARGB(255, 89, 217, 255),
            secondaryColor: Colors.grey[800]!,
            inputBackgroundColor: Colors.grey[900]!,
            inputTextColor: Colors.white,
            receivedMessageBodyTextStyle: TextStyle(color: Colors.white),
            sentMessageBodyTextStyle: TextStyle(color: Colors.white),
            inputContainerDecoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
            ),
            messageBorderRadius: 20,
          ),
        ),
      ),
    );
  }
}
