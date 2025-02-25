import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';



class UploadPDFScreen extends StatefulWidget {
  @override
  _UploadPDFScreenState createState() => _UploadPDFScreenState();
}

class _UploadPDFScreenState extends State<UploadPDFScreen> {
  File? _selectedFile;
  bool _chatStarted = false;
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot');

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _startChat() {
    if (_selectedFile != null) {
      setState(() {
        _chatStarted = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a PDF first.",
            style: GoogleFonts.lato(),
          ),
        ),
      );
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

    _getBotResponse(message.text);
  }

  void _getBotResponse(String query) async {
    String response =
        "Sample response for: $query"; // Replace with actual AI response

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatStarted ? "Chatbot" : "Upload PDF"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_chatStarted) {
              setState(() {
                _chatStarted = false;
                _messages.clear(); // Clear chat when going back
              });
            } else {
              Navigator.pop(context); // Go back from the Upload PDF page
            }
          },
        ),
      ),
      body: _chatStarted
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Chatting with: ${_selectedFile?.path.split('/').last}",
                    style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Chat(
                    messages: _messages,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                    theme: DefaultChatTheme(
                      backgroundColor: Colors.black,
                      primaryColor: Color.fromARGB(255, 89, 217, 255),
                      secondaryColor: Colors.grey[800]!,
                      inputBackgroundColor: Colors.grey[900]!,
                      inputTextColor: Colors.white,
                      receivedMessageBodyTextStyle: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      sentMessageBodyTextStyle: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      inputContainerDecoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      messageBorderRadius: 20,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickPDF,
                    child: Text(
                      "Select PDF",
                      style: GoogleFonts.lato(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800], // Fix applied here
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),

                  SizedBox(height: 10),
                  _selectedFile != null
                      ? Text(
                          "Selected: ${_selectedFile!.path.split('/').last}",
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.white),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startChat,
                    child: Text(
                      "Upload & Start Chat",
                      style: GoogleFonts.lato(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800], // Fix applied here
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),

                ],
              ),
            ),
    );
  }
}
