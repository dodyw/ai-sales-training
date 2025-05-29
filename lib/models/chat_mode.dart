enum ChatMode { roleplay, objectionHandler, pitchReview }

extension ChatModeExtension on ChatMode {
  String get displayName {
    switch (this) {
      case ChatMode.roleplay:
        return 'Roleplay';
      case ChatMode.objectionHandler:
        return 'Objection Handler';
      case ChatMode.pitchReview:
        return 'Pitch Review';
    }
  }

  String get description {
    switch (this) {
      case ChatMode.roleplay:
        return 'Practice your sales pitch with a virtual customer';
      case ChatMode.objectionHandler:
        return 'Learn how to handle common customer objections';
      case ChatMode.pitchReview:
        return 'Get feedback on your sales pitch';
    }
  }

  String get systemPrompt {
    switch (this) {
      case ChatMode.roleplay:
        return 'You are a potential customer. The user is a door-to-door sales representative trying to sell you their product. Respond as a realistic customer would, asking questions and expressing concerns. Be conversational and natural.';
      case ChatMode.objectionHandler:
        return 'You are a sales coach specializing in handling objections. The user will present common objections they face during door-to-door sales. Provide constructive advice on how to overcome these objections effectively. Include specific phrases and techniques they can use.';
      case ChatMode.pitchReview:
        return 'You are a sales pitch expert. The user will share their sales pitch with you. Analyze it and provide constructive feedback on its effectiveness, structure, persuasiveness, and areas for improvement. Be specific and actionable in your advice.';
    }
  }
}
