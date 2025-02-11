@isTest
private class OrderTriggerControllerTest {

    //Test de l'activation de plus de 100 commandes sur un compte n'en ayant aucune initialement
    @isTest
    static void updateAcctWithNoInitialOrders() {
        //Création de données de test
        Account testAccount = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList = TestDataFactory.createTestOrderList(103, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList, testPbe);
        //Activation des commandes
        Test.startTest();
            for(Order order : testOrderList) {
                order.Status = 'Activated';
            }
            update testOrderList;
        Test.stopTest();
        //Vérification du nombre de commande
        testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        List<Order> testAccountOrders = [SELECT Id FROM Order WHERE AccountId = :testAccount.Id];
        Assert.areEqual(103, testAccountOrders.size(), 'Should return 103 results');
        Assert.areEqual(195700, testAccount.Chiffre_d_affaire__c, 'Should return 195700');
    }

    //Test de l'activation de nouvelles commandes sur un compte en ayant déjà 100 initialement.
    @isTest
    static void updateAcctWithInitialOrders() {
        //Création de données de test
        Account testAccount = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList = TestDataFactory.createTestOrderList(100, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList, testPbe);
        //Activation des commandes initiales
        for(Order order : testOrderList) {
            order.Status = 'Activated';
        }
        update testOrderList;
        //Vérification du nombre de commandes et CA initiaux
        testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        List<Order> accountInitialOrders = [SELECT Id FROM Order WHERE AccountId = :testAccount.Id];
        Assert.areEqual(100, accountInitialOrders.size(), 'Should return 100 results');
        Assert.areEqual(190000, testAccount.Chiffre_d_affaire__c, 'Should return 190000');
        //Création de nouvelles commandes
        List<Order> newOrderList = TestDataFactory.createTestOrderList(2, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> newOrderItemList = TestDataFactory.createTestOrderItemList(newOrderList, testPbe);
        //Activation des nouvelles commandes
        Test.startTest();
        for(Order order : newOrderList) {
            order.Status = 'Activated';
        }
        update newOrderList;    
        Test.stopTest();
        //Vérification du nouveau CA et nombre de commandes
        testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        List<Order> testAccountOrders = [SELECT Id FROM Order WHERE AccountId = :testAccount.Id];
        Assert.areEqual(102, testAccountOrders.size(), 'Should return 102 results');
        Assert.areEqual(193800, testAccount.Chiffre_d_affaire__c, 'Should return 193800');
    }

    @isTest
    static void testCalculateTotalWithShipment() {
        Account testAccount = TestDataFactory.createTestAccount1();
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList = TestDataFactory.createTestOrderList(3, testAccount.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList, testPbe);
        Test.startTest();
        for(Order order : testOrderList) {
            order.ShipmentCost__c = 200;
        }
        update testOrderList;
        Test.stopTest();
        List<Order> orderList = [SELECT Id, TotalAmount, TotalWithShipment__c FROM Order WHERE AccountId = :testAccount.Id];
        Assert.areEqual(1900, orderList[0].TotalAmount, 'Should return 1900');
        Assert.areEqual(2100, orderList[1].TotalWithShipment__c, 'Should return 2100');
    }
}