@isTest
private class UpdateOrderItemPricesBatchTest {
    //Test du batch
    @isTest
    static void testUpdateOrderItemsPrices() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(4, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
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
        Test.startTest();
        UpdateOrderItemPricesBatch batch = new UpdateOrderItemPricesBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Order> orderListAcc1 = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId = :testAccount1.Id];
        List<OrderItem> oitList = [SELECT Id, OrderId, TotalPrice FROM OrderItem WHERE OrderId = :testOrderList2[0].Id];
        List<OrderItem> oitList2 = [SELECT Id, OrderId, TotalPrice FROM OrderItem WHERE OrderId = :testOrderList2[1].Id];
        //Vérification de la mise à jour effectuée sur les commandes Draft uniquement
        Assert.areEqual(1900, orderListAcc1[0].TotalAmount, 'Should return 1900'); //pas de mise à jour
        Assert.areEqual(2900, orderListAcc1[2].TotalAmount, 'Should return 2900'); //mis à jour
        Assert.areEqual(300, oitList[0].TotalPrice, 'Should return 300'); //pas de mise à jour
        Assert.areEqual(600, oitList2[0].TotalPrice, 'Should return 600'); // mis à jour
    }
}