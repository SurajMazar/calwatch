enum AiProvider {
  gemini('Gemini', 'Google Gemini 2.0 Flash'),
  openai('OpenAI', 'GPT-4o Vision'),
  claude('Claude', 'Anthropic Claude 3.5 Sonnet');

  final String displayName;
  final String modelDescription;

  const AiProvider(this.displayName, this.modelDescription);

  static AiProvider fromString(String value) {
    return AiProvider.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AiProvider.gemini,
    );
  }

  String get storageKey => 'ai_key_$name';
}
