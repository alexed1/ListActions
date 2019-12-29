public with sharing class ExtractStringsFromCollection {
  
    @InvocableMethod
    public static List <Results> extract (List<Requests> requestList) {
        System.debug('entering ExtractStringsFromCollection');
        List<String> outputStrings =  new List<String>();
        
        String targetField = requestList[0].fieldName;
        List<SObject>   inputCollection = requestList[0].inputCollection;
        if (inputCollection != null) {
            //take the record
            //get the value of the field
            //add it to outputSTrings
            for(SObject curObject : inputCollection) {
                outputStrings.add(String.valueOf(curObject.get(targetField)));
            }
        }
        
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

      public Requests () {
        this.inputCollection = new List<SObject>();
      }

      @InvocableVariable //don't make required because it blows up if user passes in null
      public List<SObject> inputCollection; 

      @InvocableVariable(required=true)
      public String fieldName;
        
    }
    
    public class Results {
     
      @InvocableVariable
      public List<String> stringList;

    }

}