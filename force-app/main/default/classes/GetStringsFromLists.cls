
//Given a list of SObjects, return a list of Strings corresponding to a specified fieldname
public with sharing class GetStringsFromLists {

  
    @InvocableMethod
    public static List <Results> getStrings (List<Requests> requestList) {
        System.debug('entering getStrings');
        List<AP_AllowedSubmitter__c>   inputCollection = requestList[0].inputCollection;
        String targetField = requestList[0].fullFieldNameWithObject;

        List<String> outputStrings = Collection.of(inputCollection).pluckStrings(targetField);

        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.stringList = outputStrings;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    public class Requests {
      @InvocableVariable(required=true)
      public List<AP_AllowedSubmitter__c> inputCollection; //for Spring '20 change this to a dynamic

      @InvocableVariable
      public String fullFieldNameWithObject;
        
    }
    
    public class Results {
     
      @InvocableVariable
      public List<String> stringList;

    }

}
