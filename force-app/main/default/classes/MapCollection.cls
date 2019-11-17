public with sharing class MapCollection {
    @InvocableMethod
    public static List <Results> mapCollection(List<Requests> requestList) {
        Results response = new Results();
        List<Account> inputCollection = requestList[0].inputCollection;
        List<Account> outputCollection = new List<Account>();
        String keyValuePairs = requestList[0].keyValuePairs;
        if (inputCollection != null && !inputCollection.isEmpty() && keyValuePairs != null) {
            for (Account acc : inputCollection) {
                outputCollection.add(acc.clone());
            }

            Pattern mPattern = pattern.compile('([^,:"\\s*]+)');
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

            for (String curKey : keyValue.keySet()) {
                for (Account acc : outputCollection) {
                    try{
                        acc.put(curKey, keyValue.get(curKey));
                    }catch (Exception ex){
                        response.errors+=ex.getMessage();
                    }
                }
            }
        }

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