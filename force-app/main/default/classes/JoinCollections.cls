public with sharing class JoinCollections {
    @InvocableMethod
    public static List <Results> joinCollections(List<Requests> requestList) {

        Results response = new Results();

        response.outputCollection.addAll(requestList[0].inputCollection);
        response.outputCollection.addAll(requestList[0].inputCollection2);

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;
        @InvocableVariable(required=true)
        public List<Account> inputCollection2;
    }

    public class Results {

        public Results() {
            outputCollection = new List<Account>();
        }

        @InvocableVariable
        public List<Account> outputCollection;
    }
}