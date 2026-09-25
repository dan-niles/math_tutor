import ballerina/ai;
import ballerina/http;

listener ai:Listener MathTutorListener = new (listenOn = check http:getDefaultListener());

service /MathTutor on MathTutorListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string instanceId = check durableMathTutorAgent.run(request.message);
        anydata result = check durableMathTutorAgent.waitForResult(instanceId);
        return {message: result.toString()};
    }
}
