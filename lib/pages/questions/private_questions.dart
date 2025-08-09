import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../design/colors.dart';
import 'chat_screen.dart';

class ChatPreview {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<types.Message>? messages;

  ChatPreview({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTime,
    this.messages,
  });
}

class PrivateQuestions extends StatefulWidget {
  const PrivateQuestions({super.key});

  @override
  State<PrivateQuestions> createState() => _PrivateQuestionsState();
}

class _PrivateQuestionsState extends State<PrivateQuestions> {
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

  final List<ChatPreview> _chats = [
    ChatPreview(
      id: '1',
      title: 'Вопрос о стажировке',
      lastMessage: 'Когда начинается летняя стажировка?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      messages: [
        types.TextMessage(
          author: const types.User(
            id: 'support-id',
            firstName: 'Поддержка',
          ),
          createdAt: DateTime.now()
              .subtract(const Duration(minutes: 5))
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: 'Здравствуйте! Чем могу помочь?',
        ),
        types.TextMessage(
          author: const types.User(
            id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
            firstName: 'Студент',
          ),
          createdAt: DateTime.now()
              .subtract(const Duration(minutes: 4))
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: 'Когда начинается летняя стажировка?',
        ),
      ],
    ),
    ChatPreview(
      id: '2',
      title: 'Техническая поддержка',
      lastMessage: 'Спасибо за помощь!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      messages: [
        types.TextMessage(
          author: const types.User(
            id: 'support-id',
            firstName: 'Поддержка',
          ),
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 3))
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: 'Здравствуйте! Чем могу помочь?',
        ),
        types.TextMessage(
          author: const types.User(
            id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
            firstName: 'Студент',
          ),
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: 'Спасибо за помощь!',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
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

    // Имитация загрузки сообщений
    await Future.delayed(const Duration(seconds: 1));

    final messages = [
      types.TextMessage(
        author: _support,
        createdAt: DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Здравствуйте! Чем могу помочь?',
      ),
    ];

    setState(() {
      _messages = messages;
      _isLoading = false;
    });
  }

  Future<void> _handleEndReached() async {
    // Здесь можно добавить загрузку предыдущих сообщений
    setState(() {
      _isLoading = true;
    });

    // Имитация загрузки предыдущих сообщений
    await Future.delayed(const Duration(seconds: 1));

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

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  Future<types.User?> _handleResolveUser(String userId) async {
    // Здесь можно добавить логику получения информации о пользователе
    if (userId == _support.id) return _support;
    return null;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}д назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'сейчас';
    }
  }

  void _openChat(BuildContext context, ChatPreview chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chat.id,
          title: chat.title,
          initialMessages: chat.messages,
        ),
      ),
    );
  }

  void _createNewChat(BuildContext context) {
    final newChatId = const Uuid().v4();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: newChatId,
          title: 'Новый вопрос',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: yellow,
        ),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'У вас пока нет сообщений',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Europe',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMessages,
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'Обновить',
                style: TextStyle(
                  fontFamily: 'Europe',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  onTap: () => _openChat(context, chat),
                  title: Text(
                    chat.title,
                    style: const TextStyle(
                      fontFamily: 'Europe',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Europe',
                    ),
                  ),
                  trailing: Text(
                    _formatTime(chat.lastMessageTime),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Europe',
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () => _createNewChat(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Создать новый чат',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Europe',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
