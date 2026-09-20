import ballerina/ai;

final ai:Wso2ModelProvider mathTutorModel = check ai:getDefaultModelProvider();
final ai:InMemoryVectorStore aiInmemoryvectorstore = check new ();
final ai:Wso2EmbeddingProvider aiWso2embeddingprovider = check ai:getDefaultEmbeddingProvider();
final ai:VectorKnowledgeBase aiVectorknowledgebase = new (aiInmemoryvectorstore, aiWso2embeddingprovider, ai:AUTO);
final ai:TextDataLoader aiTextdataloader = check new (
    "resources/kb/quadratic_formula.md",
    "resources/kb/order_of_operations.md",
    "resources/kb/grading_policy.md"
);
