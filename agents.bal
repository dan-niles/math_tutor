import ballerina/ai;

# Searches the course knowledge base (grading policy, order of operations, quadratic formula
# reference material) for content relevant to the given query. Use this for any question about
# course policies, grading rules, penalties, or reference material that is not a direct calculation.
# + query - The text query to search for
# + return - The matching knowledge base chunks ranked by relevance
@ai:AgentTool
@display {label: "", iconPath: "https://bcentral-packageicons.azureedge.net/images/ballerina_ai_1.15.0.png"}
isolated function retrieveTool(string query) returns ai:QueryMatch[]|error {
    ai:QueryMatch[] aiQuerymatch = check aiVectorknowledgebase.retrieve(query);
    return aiQuerymatch;
}

final ai:Agent mathTutorAgent = check new (
    systemPrompt = {
        role: string `Math Tutor`,
        instructions: string `You are a math tutor assistant.

RULES (MUST FOLLOW):

* You MUST use the provided mathematical tools (add, subtract, multiply, divide) for ALL calculations, even simple ones.
* You are NOT allowed to compute results mentally or inline.
* If a calculation is required and a tool is available, you MUST call the tool.
* If you do not call a tool when a calculation is required, the response is invalid.
* For questions about course policies, grading, penalties, or other reference material (for example, late problem set penalties or the order of operations), you MUST call the retrieveTool with the user's question to search the knowledge base before answering.
* Base your answer only on the content returned by retrieveTool for such questions. If retrieveTool returns no relevant information, say that you could not find that information instead of guessing.

Provide clear, step-by-step explanations. Include the final answer at the end.`
    }, memory = aiShorttermmemory, model = mathTutorModel, tools = [sumTool, subtractTool, multiplyTool, divideTool, retrieveTool], verbose = false
);

# Calculates the sum of two numbers
#
# + num1 - The first number
# + num2 - The second number
# + return - The sum of num1 and num2
@ai:AgentTool
@display {label: "", iconPath: ""}
isolated function sumTool(float num1, float num2) returns float {
    return num1 + num2;
}

# Calculates the difference of two numbers
#
# + num1 - The first number
# + num2 - The second number
# + return - The difference of num1 and num2
@ai:AgentTool
@display {label: "", iconPath: ""}
isolated function subtractTool(float num1, float num2) returns float {
    return num1 - num2;
}

# Calculates the product of two numbers
# + num1 - The first number
# + num2 - The second number
# + return - The product of num1 and num2
@ai:AgentTool
@display {label: "", iconPath: ""}
isolated function multiplyTool(float num1, float num2) returns float {
    return num1 * num2;
}

# Calculates the division of two numbers
# Handles division by zero
# If num2 is zero, returns 0
# Otherwise, returns the result of the division
#
# + num1 - The dividend (numerator)
# + num2 - The divisor (denominator)
# + return - The quotient of num1 divided by num2, or 0 if num2 is zero
@ai:AgentTool
@display {label: "", iconPath: ""}
isolated function divideTool(float num1, float num2) returns float {
    if (num2 == 0.0) {
        return 0.0;
    }
    return num1 / num2;
}

final ai:ShortTermMemory aiShorttermmemory = check new (aiInmemoryshorttermmemorystore);

final ai:InMemoryShortTermMemoryStore aiInmemoryshorttermmemorystore = check new (20);
