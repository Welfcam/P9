@isTest
private class UpdateOrderItemPricesBatchSchedulerTest {

    @isTest
    static void testSchedulerToUpdatePrices() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(20, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(30, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        testOrderList1[0].Status = 'Activated';
        testOrderList1[1].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        for(PricebookEntry pbe : testpbe) {
            pbe.UnitPrice += 100;
        }
        update testpbe;
        List<Account> listAcctToCheckCA1 = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        List<Order> listOrderToCheckTotalAmount1 = [SELECT Id, TotalAmount FROM Order WHERE TotalAmount = 1900 AND Status = 'Draft'];
        String jobName = 'Test Scheduler To Update Draft Order Prices';
        UpdateOrderItemPricesBatchScheduler testScheduler = new UpdateOrderItemPricesBatchScheduler();
        String cronExp = '0 0 0 ? * 2 *'; //exécution à minuit tous les Lundi
        Test.startTest();
        Id jobId = System.schedule(jobName, cronExp, testScheduler);
        Test.stopTest();
        CronTrigger scheduledJob = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId LIMIT 1];
        System.assertEquals('WAITING', scheduledJob.State, 'The job should be in waitind status');
    }
}