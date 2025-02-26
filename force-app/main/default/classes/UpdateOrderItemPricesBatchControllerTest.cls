@isTest
private class UpdateOrderItemPricesBatchControllerTest {

    //Test du Batch de mise à jour des prix
    @isTest
    static void testUpdateOrderItemsPrices() {
        //Création de comptes de test
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        //Création d'une liste de produits
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        //Création de pricebook entries
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        //Création d'une liste de commandes en Draft pour chaque compte, avec le standard pricebook
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(4, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        //Création d'une liste de 3 orderItem pour chaque commande
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        //Activation de 2 commandes du compte 1 et d'1 commande du compte 2
        testOrderList1[0].Status = 'Activated';
        testOrderList1[1].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        //Mise à jour du prix des produits
        for(PricebookEntry pbe : testpbe) {
            pbe.UnitPrice += 100;
        }
        update testpbe;
        //Lancement du batch
        Test.startTest();
        UpdateOrderItemPricesBatchController.runUpdateOrderItemPricesBatch();
        Test.stopTest();
        List<Order> orderListAcc1 = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId = :testAccount1.Id];
        List<OrderItem> oitList = [SELECT Id, OrderId, TotalPrice FROM OrderItem WHERE OrderId = :testOrderList2[0].Id];
        List<OrderItem> oitList2 = [SELECT Id, OrderId, TotalPrice FROM OrderItem WHERE OrderId = :testOrderList2[1].Id];
        //Vérification du totalAmount de la 1er commande activée du compte 1 (pas de changement)
        Assert.areEqual(1900, orderListAcc1[0].TotalAmount, 'Should return 1900');
        //Vérification du totalAmount d'une des commandes Draft du compte 1 (mise à jour)
        Assert.areEqual(2900, orderListAcc1[2].TotalAmount, 'Should return 2900');
        //Vérification du prix d'un produit dans une commande activée (pas de changement)
        Assert.areEqual(300, oitList[0].TotalPrice, 'Should return 300');
        //Vérification du prix d'un produit dans une commande draft (mis à jour)
        Assert.areEqual(600, oitList2[0].TotalPrice, 'Should return 600');
    }
}