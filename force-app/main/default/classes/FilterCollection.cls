public with sharing class FilterCollection {
    @InvocableMethod
    public static List <Results> filter(List<Requests> requestList) {

        String formulaString = requestList[0].formula;
        List<Account> inputCollection = requestList[0].inputCollection;
        List<Account> outputCollection = new List<Account>();

        for(Account acc: inputCollection){
            List<FormulaEvaluator.ContextWraper> context = new List<FormulaEvaluator.ContextWraper>();
            context.add(new FormulaEvaluator.ContextWraper('$Record', acc.Id));
            String stringContext = JSON.serialize(context);
            String result = FormulaEvaluator.parseFormula(formulaString, stringContext);
            if(result == 'true') {
                outputCollection.add(acc);
            }
        }

        Results response = new Results();
        response.outputCollection = outputCollection;
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;

    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;

        @InvocableVariable
        public String formula;

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