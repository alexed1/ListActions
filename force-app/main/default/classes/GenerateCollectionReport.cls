public with sharing class GenerateCollectionReport {
    @InvocableMethod
    public static List <Results> generateReport(List<Requests> requestList) {

        List<SObject> inputCollection = requestList[0].inputCollection;
        String shownFields = requestList[0].shownFields;
        String reportString = '';
        if (inputCollection != null && !inputCollection.isEmpty() && shownFields != null) {
            reportString += 'Collection Type: ' + inputCollection[0].getSObjectType().getDescribe().getName() + '\n\n';
            List<String> shownFieldsArray = shownFields.replaceAll('[^a-zA-Z0-9\\,]', '').split(',');
            if (!shownFieldsArray.isEmpty()) {
                for (SObject acc : inputCollection) {
                    reportString += 'Record: ' + (acc.get('Name') != null ? acc.get('Name') : (acc.get('Id') != null ? acc.get('Id') : ''))+'\n';
                    for (String fieldName : shownFieldsArray) {
                        reportString += fieldName + ' : ' + acc.get(fieldName)+'\n';
                    }
                    reportString += '\n\n';
                }
            }
        }

        Results response = new Results();
        response.reportString = reportString;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;


    }
    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;

        @InvocableVariable(required=true)
        public String shownFields;

    }

    public class Results {

        @InvocableVariable
        public String reportString;

    }
}