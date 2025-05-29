import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/chat_mode.dart';
import '../models/user_profile.dart';
import 'openrouter_service.dart';

class ChatService extends ChangeNotifier {
  final OpenRouterService _openRouterService = OpenRouterService();
  final List<ChatMessage> _messages = [];
  ChatMode _currentMode = ChatMode.roleplay;
  UserProfile? _userProfile;
  bool _isLoading = false;
  final _uuid = Uuid();

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  ChatMode get currentMode => _currentMode;
  bool get isLoading => _isLoading;
  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void setMode(ChatMode mode) {
    _currentMode = mode;
    _messages.clear();
    notifyListeners();

    // Add system message based on the selected mode
    _addSystemMessage();
  }

  void _addSystemMessage() {
    // Add a welcome message based on the current mode
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      text: _getWelcomeMessage(),
      isUser: false,
      timestamp: DateTime.now(),
    );
    _messages.add(welcomeMessage);
    notifyListeners();
  }

  String _getWelcomeMessage() {
    if (_userProfile == null) {
      return 'Please set up your profile before starting a conversation.';
    }

    switch (_currentMode) {
      case ChatMode.roleplay:
        return 'Hello! I\'m a potential customer. Go ahead and start your sales pitch for ${_userProfile!.productType}.';
      case ChatMode.objectionHandler:
        return 'I\'m your objection handling coach. Share a common objection you face when selling ${_userProfile!.productType}, and I\'ll help you overcome it.';
      case ChatMode.pitchReview:
        return 'I\'m your pitch review expert. Share your sales pitch for ${_userProfile!.productType}, and I\'ll provide feedback to help you improve.';
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      // Convert messages to the format expected by the API
      final apiMessages = _prepareMessagesForApi();

      // Get response from AI
      final responseText = await _openRouterService.generateResponse(
        apiMessages,
      );

      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(aiMessage);
    } catch (e) {
      print('Error sending message: $e');
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> _prepareMessagesForApi() {
    final List<Map<String, String>> apiMessages = [];

    // Add system message with the appropriate prompt for the current mode
    apiMessages.add({'role': 'system', 'content': _currentMode.systemPrompt});

    // Add user profile context
    if (_userProfile != null) {
      apiMessages.add({
        'role': 'system',
        'content':
            'User information: Name: ${_userProfile!.name}, Company: ${_userProfile!.company}, Product: ${_userProfile!.productType}, Experience: ${_userProfile!.experience}',
      });
    }

    // Add conversation history (skip the welcome message)
    for (int i = 1; i < _messages.length; i++) {
      final message = _messages[i];
      apiMessages.add({
        'role': message.isUser ? 'user' : 'assistant',
        'content': message.text,
      });
    }

    return apiMessages;
  }

  void clearChat() {
    _messages.clear();
    _addSystemMessage();
    notifyListeners();
  }
}
