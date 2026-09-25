import ballerina/ai;
import ballerina/http;

listener ai:Listener MathTutorListener = new (listenOn = check http:getDefaultListener());

service /MathTutor on MathTutorListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check mathTutorAgent.run(request.message, request.sessionId);

        return {message: stringResult};
    }

    # Starts a durable run of the math tutor agent and waits for its result. The run survives
    # a service restart or crash: calling waitForResult again with the same instance ID resumes
    # the wait instead of losing progress.
    resource function post durableChat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string instanceId = check durableMathTutorAgent.run(request.message);
        anydata result = check durableMathTutorAgent.waitForResult(instanceId);
        return {message: result.toString()};
    }
}
