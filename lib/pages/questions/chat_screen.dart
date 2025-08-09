import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../design/colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final List<types.Message>? initialMessages;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.title,
    this.initialMessages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  bool _isLoading = true;

  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'Студент',
  );

  final _support = const types.User(
    id: 'support-id',
    firstName: 'Поддержка',
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    // Имитация ответа от поддержки через 1 секунду
    await Future.delayed(const Duration(seconds: 1));
    final supportMessage = types.TextMessage(
      author: _support,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text:
          'Спасибо за ваш вопрос! Мы обязательно на него ответим в ближайшее время.',
    );
    _addMessage(supportMessage);
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Если есть начальные сообщения, используем их
    if (widget.initialMessages != null) {
      _messages = widget.initialMessages!;
    } else {
      // Для нового чата добавляем приветственное сообщение
      _messages = [
        types.TextMessage(
          author: _support,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text:
              'Здравствуйте! Задайте ваш вопрос, и мы постараемся ответить как можно скорее.',
        ),
      ];
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.ImageMessage) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(
              backgroundColor: yellow,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Просмотр изображения',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Europe',
                ),
              ),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.file(
                  File(message.uri),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: yellow,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Europe',
          ),
        ),
      ),
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleImageSelection,
        onMessageTap: _handleMessageTap,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          backgroundColor: Colors.white,
          primaryColor: yellow,
          secondaryColor: Color(0xFFF3F3F3),
          inputBackgroundColor: Color(0xFFF2F2F2),
          inputTextColor: Colors.black,
          messageBorderRadius: 20,
          sentMessageBodyTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Europe',
          ),
          receivedMessageBodyTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Europe',
          ),
        ),
        showUserAvatars: true,
        showUserNames: true,
      ),
    );
  }
}
