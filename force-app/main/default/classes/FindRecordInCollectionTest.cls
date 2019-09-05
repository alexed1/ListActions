@isTest
public  class FindRecordInCollectionTest {
    
    @isTest
    static void FindRecordFindsCorrectly() {
         ApprovalProcessStepDefinition__c targetMember = FixtureData.OutputRecord1();

        List<FindRecordsInCollection.Requests> testRequestList = new List<FindRecordsInCollection.Requests>();
        FindRecordsInCollection.Requests testRequest = new  FindRecordsInCollection.Requests();
        testRequest.inputCollection = FixtureData.InputCollection1();
        testRequest.targetObject = 'ApprovalProcessStepDefinition__c';
        testRequest.targetField = 'Name';
        testRequest.targetValue = 'step3';
        testRequestList.add(testRequest);

        System.debug('testRequestList: ' + testRequestList);
        FindRecordsInCollection.Results results = FindRecordsInCollection.execute(testRequestList)[0];
        
        ApprovalProcessStepDefinition__c singleOutputMember = results.singleOutputMember;
        System.assertEquals(singleOutputMember.name, targetMember.name, 'FindRecordsInCollection names do not match');

    }
}

