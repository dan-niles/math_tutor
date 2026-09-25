import ballerinax/ai.anthropic;

final anthropic:ModelProvider mathTutorModel = check new (anthropicApiKey, anthropic:CLAUDE_HAIKU_4_5);
