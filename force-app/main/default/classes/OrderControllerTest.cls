@isTest
private class OrderControllerTest {

    //test de la méthode getSumActivatedOrdersByAccount
    @isTest
    static void getSumWhenDraftAndActivatedOrders() {
        //Création d'une liste de comptes (sans CA)
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Account> acctList = new List<Account>();
        acctList.add(testAccount1);
        acctList.add(testAccount2);
        //Création d'une liste de produits
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        //Création de Pricebook Entries
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        //Création d'1 liste de commandes en Draft pour chaque compte, avec le standardPricebook
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(2, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(3, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        //Création d'1 liste d'orderItem pour chaque Order (3 produit1 à 100€, 5 produit2 à 200€, 2 produit3 à 500€)
        //Le totalAmount de chaque commande est de 1900€
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        //Activation d'1 commande du Compte 1 et de 2 commandes du compte 2
        testOrderList1[0].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        testOrderList2[1].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        //Ajout des Id des comptes dans un set utilisé dans la méthode testée
        Set<Id> setAccountIds = new Set<Id>();
        for(Account acct : acctList) {
            setAccountIds.add(acct.Id);
        }
        Test.startTest();
        List<AggregateResult> result = OrderController.getSumActivatedOrdersByAccounts(setAccountIds);
        Test.stopTest();
        //Vérification du nombre de résultats retournés
        Assert.areEqual(2, result.size(), 'Should return 2 results');
        //Création d'une map pour stocker les résultats attendus (Id et somme des commandes correspondantes)
        Map<Id, Decimal> expectedSums = new Map<Id, Decimal>();
        expectedSums.put(testAccount1.Id, 1900);
        expectedSums.put(testAccount2.Id, 3800);
        //Pour chaque résultat de la liste result, on extrait les données à tester
        for(AggregateResult res : result) {
            Id accountId = (Id) res.get('AccountId');
            Decimal orderSum = (Decimal) res.get('total');
            //On vérifie que les données de récupérées correspondent aux données attendues de la Map
            Assert.areEqual(expectedSums.get(accountId), orderSum, 'The sum returned is not the same');
        }
    }
}