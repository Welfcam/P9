@isTest
private class OrderControllerTest {

    @isTest
    static void getSumWhenOnlyDraftOrders() {
        Account testAccount = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList = TestDataFactory.createTestOrderList(5, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList, testPbe);
        Test.startTest();
        Decimal total = OrderController.getSumActivatedOrdersByAccount(testAccount.Id);
        Test.stopTest();
        Assert.areEqual(null, total, 'Should return null');
    }

    @isTest
    static void getSumWhen2DraftAnd3ActivatedOrders() {
        Account testAccount = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList = TestDataFactory.createTestOrderList(5, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList, testPbe);
        testOrderList[0].Status = 'Activated';
        testOrderList[1].Status = 'Activated';
        testOrderList[2].Status = 'Activated';
        update testOrderList;
        Test.startTest();
        Decimal total = OrderController.getSumActivatedOrdersByAccount(testAccount.Id);
        Test.stopTest();
        Assert.areEqual(5700, total, 'Should return 5700');
    }
}