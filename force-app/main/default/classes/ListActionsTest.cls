@isTest
public with sharing class ListActionsTest {
    private final static Integer NUMBER_OF_TEST_RECORDS = 5;
    private final static String TEST_RECORD_NAME = 'Test Acc';
    @isTest
    static void copyCollectionTest() {
        List<CopyCollection.Requests> requests = new List<CopyCollection.Requests>();
        CopyCollection.Requests request = new CopyCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        requests.add(request);
        List<CopyCollection.Results> responseWrapper = CopyCollection.copyCollection(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(responseWrapper[0].outputCollection.size(), NUMBER_OF_TEST_RECORDS);
        for (Integer i = 0; i < NUMBER_OF_TEST_RECORDS; i++) {
            System.assertEquals(responseWrapper[0].outputCollection[i].Name, testAccounts[i].Name);
        }
    }

    @isTest
    static void filterCollectionTest() {
        List<FilterCollection.Requests> requests = new List<FilterCollection.Requests>();
        FilterCollection.Requests request = new FilterCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.formula = 'OR(CONTAINS($Account.Name,"2"),CONTAINS($Account.Name,"3"))';
        requests.add(request);
        List<FilterCollection.Results> responseWrapper = FilterCollection.filter(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(2, responseWrapper[0].outputCollection.size());
    }
    @isTest
    static void joinCollectionTest() {
        List<JoinCollections.Requests> requests = new List<JoinCollections.Requests>();
        JoinCollections.Requests request = new JoinCollections.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        List<Account> testAccounts2 = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.inputCollection2 = testAccounts2;
        requests.add(request);
        List<JoinCollections.Results> responseWrapper = JoinCollections.joinCollections(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(10, responseWrapper[0].outputCollection.size());

    }
    @isTest
    static void mapCollection() {
        final Map<String, String> fieldNameValue = new Map<String, String>{
                'Website' => 'www.site.com',
                'Name' => 'DifferentName'
        };

        List<MapCollection.Requests> requests = new List<MapCollection.Requests>();
        MapCollection.Requests request = new MapCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.keyValuePairs = '';
        for (String fieldName : fieldNameValue.keySet()) {
            request.keyValuePairs += '"' + fieldName + '":"' + fieldNameValue.get(fieldName) + '",';
            request.keyValuePairs.removeEnd(',');
        }

        requests.add(request);
        List<MapCollection.Results> responseWrapper = MapCollection.mapCollection(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());
        for (Account acc : responseWrapper[0].outputCollection) {
            for (String fieldName : fieldNameValue.keySet()) {
                System.assertEquals(fieldNameValue.get(fieldName), acc.get(fieldName));
            }
        }
    }

    @isTest
    static void removeRecordInCollectionTest() {
        final Integer INDEX_TO_REMOVE = 0;
        List<RemoveRecordInCollection.Requests> requests = new List<RemoveRecordInCollection.Requests>();
        RemoveRecordInCollection.Requests request = new RemoveRecordInCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        request.inputCollection = testAccounts;
        request.index = INDEX_TO_REMOVE;
        requests.add(request);
        String accountNameToRemove = testAccounts[INDEX_TO_REMOVE].Name;
        List<RemoveRecordInCollection.Results> responseWrapper = RemoveRecordInCollection.removeRecordByIndex(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS - 1, responseWrapper[0].outputCollection.size());
        System.assertNotEquals(responseWrapper[0].outputCollection[0].Name, accountNameToRemove);
    }

    @isTest
    static void sortCollectionTest() {
        final Map<String, String> sortDirection = new Map<String, String>{
                'NumberOfEmployees' => 'ASC',
                'Name' => 'DESC',
                'Site' => 'ASC'
        };
        List<SortCollection.Requests> requests = new List<SortCollection.Requests>();
        SortCollection.Requests request = new SortCollection.Requests();
        List<Account> testAccounts = createAccounts(NUMBER_OF_TEST_RECORDS, true);
        testAccounts[NUMBER_OF_TEST_RECORDS - 1].NumberOfEmployees = 2;
        testAccounts[NUMBER_OF_TEST_RECORDS - 2].NumberOfEmployees = 3;
        testAccounts[NUMBER_OF_TEST_RECORDS - 3].NumberOfEmployees = 5;
        request.inputCollection = testAccounts;
        request.sortKeys = '';
        for (String fieldName : sortDirection.keySet()) {
            request.sortKeys += '"' + fieldName + '":"' + sortDirection.get(fieldName) + '",';
            request.sortKeys.removeEnd(',');
        }
        requests.add(request);
        String firstAccountName = testAccounts[0].Name;
        List<SortCollection.Results> responseWrapper = SortCollection.sort(requests);
        System.assertEquals(responseWrapper.size(), 1);
        System.assertEquals(NUMBER_OF_TEST_RECORDS, responseWrapper[0].outputCollection.size());

        System.assertEquals(responseWrapper[0].outputCollection[NUMBER_OF_TEST_RECORDS - 1].Name, firstAccountName);
    }

    public static List<Account> createAccounts(Integer numberOfRecords, Boolean doInsert) {

        List<Account> returnList = new List<Account>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            returnList.add(new Account(Name = TEST_RECORD_NAME + i, Website = '' + i));
        }
        if (doInsert) {
            insert returnList;
        }

        return returnList;
    }
}