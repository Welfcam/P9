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
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(20, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(30, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
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

        List<Account> listAcctToCheckCA1 = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        List<Order> listOrderToCheckTotalAmount1 = [SELECT Id, TotalAmount FROM Order WHERE TotalAmount = 1900 AND Status = 'Draft'];
        Test.startTest();
        UpdateOrderItemPricesBatchController.runUpdateOrderItemPricesBatch();
        Test.stopTest();
        List<Account> listAcctToCheckCA2 = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        List<Order> listOrderToCheckTotalAmount2 = [SELECT Id, TotalAmount FROM Order WHERE TotalAmount = 1900 AND Status = 'Draft'];
        List<Order> listOrderToCheckTotalAmount3 = [SELECT Id, TotalAmount FROM Order WHERE TotalAmount = 2900 AND Status = 'Draft'];
        Assert.areEqual(2, listAcctToCheckCA1.size(), 'Should return 2 results');
        //Vérifie que le CA des comptes, donc des commandes activées, n'a pas changé après la mise à jour du prix des produits par le Batch
        Assert.areEqual(listAcctToCheckCA2[0].Chiffre_d_affaire__c, listAcctToCheckCA1[0].Chiffre_d_affaire__c, 'Should return same Amount (3800)');
        Assert.areEqual(listAcctToCheckCA2[1].Chiffre_d_affaire__c, listAcctToCheckCA1[1].Chiffre_d_affaire__c, 'Should return same Amount (1900)');
        //Vérifie le nombre de commandes en draft avec un totalAmount de 1900 avant le batch
        Assert.areEqual(47, listOrderToCheckTotalAmount1.size(), 'Should return 47 results');
        //Vérifie qu'il n'a plus de commandes en draft avec un totalAmount de 1900 après le batch
        Assert.areEqual(0, listOrderToCheckTotalAmount2.size(), 'Should return 0 results');
        //Vérifie qu'il y a 97 commandes avec un totalAmount de 2900, après le batch
        Assert.areEqual(47, listOrderToCheckTotalAmount3.size(), 'Should return 47 results');
    }
}