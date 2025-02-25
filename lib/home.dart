import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:npci/profile.dart';
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
      backgroundColor: Colors.black, // Dark background
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
          // SettingsScreen(),
          // NotificationsScreen(),
          Profiles(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900], // Dark navbar
        selectedItemColor: Colors.white, // Highlighted icon color
        unselectedItemColor: Colors.grey, // Non-selected icon color
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: "PDF"),
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

  const ChatScreenContent(
      {required this.messages,
      required this.onSendPressed,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increased Navbar Height
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900], // Dark AppBar Color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), // Rounded bottom corners
              bottomRight: Radius.circular(30),
            ),
          ),
          child: AppBar(
            backgroundColor:
                Colors.transparent, // Transparent for rounded effect
            elevation: 0, // No shadow
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center logo & text
              children: [
                Container(
                  height: 90,
                  width: 90,
                  child: Image.asset(
                    'assets/logo.png', // Replace with your logo path
                    height: 40, // Adjust size as needed
                  ),
                ),
                SizedBox(width: 10), // Space between logo and text
                Text(
                  "Chatbot",
                  style: TextStyle(
                    fontSize: 28, // Larger font
                    fontWeight: FontWeight.bold, // Bold text
                    letterSpacing: 1.2, // Slight spacing for better look
                    color: Colors.white, // Text color
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
            backgroundColor: Colors.black, // Chat background
            primaryColor: Color.fromARGB(255, 89, 217, 255), // User message color
            secondaryColor: Colors.grey[800]!, // Bot message color
            inputBackgroundColor: Colors.grey[900]!, // Input field background
            inputTextColor: Colors.white, // Input text color
            receivedMessageBodyTextStyle: TextStyle(color: Colors.white),
            sentMessageBodyTextStyle: TextStyle(color: Colors.white),
            inputContainerDecoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
            ),
            messageBorderRadius: 20, // **Round corners for all messages**
          ),

        ),
      ),
    );
  }
}

// Dark themed Settings Screen
