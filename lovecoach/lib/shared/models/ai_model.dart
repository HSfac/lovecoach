enum AIModel {
  openai('OpenAI GPT-3.5', 'gpt-3.5-turbo', '빠르고 정확한 응답'),
  claude('Claude 3.5 Sonnet', 'claude-3-5-sonnet-20241022', '더욱 깊이 있는 상담');

  const AIModel(this.displayName, this.modelId, this.description);
  
  final String displayName;
  final String modelId;
  final String description;

  static AIModel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'claude':
        return AIModel.claude;
      case 'openai':
      default:
        return AIModel.openai;
    }
  }

  String get provider {
    switch (this) {
      case AIModel.openai:
        return 'OpenAI';
      case AIModel.claude:
        return 'Anthropic';
    }
  }

  String get icon {
    switch (this) {
      case AIModel.openai:
        return '🤖';
      case AIModel.claude:
        return '🧠';
    }
  }
}