import ballerina/ai;
import ballerina/workflow;

# Searches the course knowledge base (grading policy, order of operations, quadratic formula
# reference material) for content relevant to the given query. Use this for any question about
# course policies, grading rules, penalties, or reference material that is not a direct calculation.
# + query - A short, keyword-style search phrase capturing the topic (for example "late problem
# set penalty" or "quadratic formula worked example"), not the user's full verbatim question
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
* For questions about course policies, grading, penalties, or reference material (for example, late problem set penalties, the order of operations, the quadratic formula, or a worked example of reference material), you MUST call retrieveTool before answering.
* When calling retrieveTool, pass a short, keyword-style search phrase that captures the topic (for example "late problem set penalty" or "quadratic formula worked example") instead of the user's full verbatim question.
* Follow-up questions that ask for more on the same reference topic (for example, a worked example after asking for a formula) also require a new retrieveTool call with a query describing that follow-up topic; do not rely on memory of an earlier answer.
* Base your answer only on the content returned by retrieveTool for such questions. If retrieveTool returns no relevant information, say that you could not find that information instead of guessing.
* When retrieveTool returns a formula, a final numeric answer, or another key fact, quote it in your response exactly as written in the retrieved content (same symbols, spacing, and punctuation), rather than paraphrasing or reformatting it. You may still add explanation around it.

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

# A durable version of the math tutor agent. Runs and conversation state survive process
# restarts and crashes, resuming from recorded history instead of starting over.
final workflow:DurableAgent durableMathTutorAgent = check new ({
    systemPrompt: {
        role: string `Math Tutor`,
        instructions: string `You are a math tutor assistant.

RULES (MUST FOLLOW):

* You MUST use the provided mathematical tools (add, subtract, multiply, divide) for ALL calculations, even simple ones.
* You are NOT allowed to compute results mentally or inline.
* If a calculation is required and a tool is available, you MUST call the tool.
* If you do not call a tool when a calculation is required, the response is invalid.
* For questions about course policies, grading, penalties, or reference material (for example, late problem set penalties, the order of operations, the quadratic formula, or a worked example of reference material), you MUST call retrieveTool before answering.
* When calling retrieveTool, pass a short, keyword-style search phrase that captures the topic (for example "late problem set penalty" or "quadratic formula worked example") instead of the user's full verbatim question.
* Follow-up questions that ask for more on the same reference topic (for example, a worked example after asking for a formula) also require a new retrieveTool call with a query describing that follow-up topic; do not rely on memory of an earlier answer.
* Base your answer only on the content returned by retrieveTool for such questions. If retrieveTool returns no relevant information, say that you could not find that information instead of guessing.
* When retrieveTool returns a formula, a final numeric answer, or another key fact, quote it in your response exactly as written in the retrieved content (same symbols, spacing, and punctuation), rather than paraphrasing or reformatting it. You may still add explanation around it.

Provide clear, step-by-step explanations. Include the final answer at the end.`
    },
    model: mathTutorModel,
    tools: [sumTool, subtractTool, multiplyTool, divideTool, retrieveTool]
});
