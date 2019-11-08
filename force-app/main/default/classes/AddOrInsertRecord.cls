public with sharing class AddOrInsertRecord {
    @InvocableMethod
    public static List <Results> copyCollection(List<Requests> requestList) {

        Results response = new Results();
        List<Account> inputCollection = requestList[0].inputCollection;
        Account inputRecord = requestList[0].inputRecord;
        Integer index = requestList[0].index;

        if (index == null || index >= inputCollection.size()) {
            inputCollection.add(inputRecord);
        } else {
            inputCollection.add(index, inputRecord);
        }

        response.outputCollection = inputCollection.clone();

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;
        @InvocableVariable(required=true)
        public Account inputRecord;
        @InvocableVariable
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