public class FixtureData {
    
    public static List<ApprovalProcessStepDefinition__c>  InputCollection1() {
        List<ApprovalProcessStepDefinition__c> inputCollection = new  List<ApprovalProcessStepDefinition__c>();
        
        ApprovalProcessStepDefinition__c stepDef1 = new ApprovalProcessStepDefinition__c();
        stepDef1.Name = 'step1';
        inputCollection.add(stepDef1);

        ApprovalProcessStepDefinition__c stepDef2 = new ApprovalProcessStepDefinition__c();
        stepDef1.Name = 'step2';
        inputCollection.add(stepDef2);

        ApprovalProcessStepDefinition__c stepDef3 = new ApprovalProcessStepDefinition__c();
        stepDef1.Name = 'step3';
        inputCollection.add(stepDef3);
        return inputCollection;
    }

    public static ApprovalProcessStepDefinition__c  OutputRecord1() {
        ApprovalProcessStepDefinition__c stepDef1 = new ApprovalProcessStepDefinition__c();
        stepDef1.Name = 'step3';
        return stepDef1;
    }
}
