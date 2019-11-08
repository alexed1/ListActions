public with sharing class RemoveRecordInCollection {
    @InvocableMethod
    public static List <Results> removeRecordByIndex(List<Requests> requestList) {

        Results response = new Results();

        response.outputCollection.addAll(requestList[0].inputCollection);
        if (requestList[0].index != null && requestList[0].index < response.outputCollection.size()) {
            response.outputCollection.remove(requestList[0].index);
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;
        @InvocableVariable(required=true)
        public Integer index;
    }

    public class Results {

        public Results() {
            outputCollection = new List<Account>();
        }

        @InvocableVariable
        public List<Account> outputCollection;
    }
}