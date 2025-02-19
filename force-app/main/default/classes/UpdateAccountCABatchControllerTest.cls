@isTest
private class UpdateAccountCABatchControllerTest {

    @isTest
    static void calculateCAwhithActivatedOrders() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(3, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        testOrderList1[0].Status = 'Activated';
        testOrderList1[1].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        Test.startTest();
        UpdateAccountCABatchController.runUpdateAccountCABatchController();
        Test.stopTest();
        List<Account> acctList = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account];
        Assert.areEqual(3800, acctList[0].Chiffre_d_affaire__c, 'Should return 3800');
        Assert.areEqual(1900, acctList[1].Chiffre_d_affaire__c, 'Should return 1900');
    }

    @isTest
    static void calculateCAwhithOrderRevertsToDraft() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(3, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        testOrderList1[0].Status = 'Activated';
        testOrderList1[1].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        testOrderList1[1].Status = 'Draft';
        update testOrderList1;
        Test.startTest();
        UpdateAccountCABatchController.runUpdateAccountCABatchController();
        Test.stopTest();
        List<Account> acctList = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account];
        Assert.areEqual(1900, acctList[0].Chiffre_d_affaire__c, 'Should return 1900');
        Assert.areEqual(1900, acctList[1].Chiffre_d_affaire__c, 'Should return 1900');
    }

    @isTest
    static void calculateCAAccountOrderAtZero() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        for(PricebookEntry pbe : testPbe) {
            pbe.UnitPrice = 0;
        }
        update testpbe;
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(2, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        testOrderList1[0].Status = 'Activated';
        testOrderList1[1].Status = 'Activated';
        update testOrderList1;
        Test.startTest();
        UpdateAccountCABatchController.runUpdateAccountCABatchController();
        Test.stopTest();
        Account acct = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount1.Id];
        Assert.areEqual(0, acct.Chiffre_d_affaire__c, 'Should return 0');
    }
}