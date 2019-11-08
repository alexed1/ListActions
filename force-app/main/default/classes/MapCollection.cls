public with sharing class MapCollection {
    @InvocableMethod
    public static List <Results> mapCollection(List<Requests> requestList) {

        String keyValuePairs = requestList[0].keyValuePairs;

        Pattern mPattern = pattern.compile('([^,"\\s*]+)');
        Matcher mMatcher = mPattern.matcher(keyValuePairs);
        Map<String, String> keyValue = new Map<String, String>();
        String key;
        while (mMatcher.find()) {
            if (key == null) {
                key = mMatcher.group(0);
            } else {
                keyValue.put(key, mMatcher.group(0));
                key = null;
            }
        }
        List<Account> outputCollection = new List<Account>();
        List<Account> inputCollection = requestList[0].inputCollection;

        for (String curKey : keyValue.keySet()) {
            for (Account acc : inputCollection) {
                Account newAcc = acc.clone();
                newAcc.put(curKey, keyValue.get(curKey));
                outputCollection.add(newAcc);
            }
        }

        Results response = new Results();
        response.outputCollection = outputCollection;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;


    }
    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;

        @InvocableVariable(required=true)
        public String keyValuePairs;

    }

    public class Results {

        public Results() {
            outputCollection = new List<Account>();
        }
        @InvocableVariable
        public String errors;

        @InvocableVariable
        public List<Account> outputCollection;
    }
}