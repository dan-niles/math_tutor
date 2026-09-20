import ballerina/ai;
import ballerina/log;

public function main() returns error? {
    do {
        ai:Document[]|ai:Document documents = check aiTextdataloader.load();
        check aiVectorknowledgebase.ingest(documents);

        int count = documents is ai:Document[] ? documents.length() : 1;
        log:printInfo("Ingested documents into the knowledge base", count = count);

        ai:QueryMatch[] matches = check aiVectorknowledgebase.retrieve("late problem set penalty");
        log:printInfo("Retrieval check", matchCount = matches.length());
        foreach ai:QueryMatch m in matches {
            log:printInfo("Match", score = m.similarityScore, content = m.chunk.content);
        }
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
