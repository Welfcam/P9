@isTest
private class AccountControllerTest {

    //Test de la méthode qui met à jour le CA des comptes
    @isTest
    static void testUpdateAccountCA() {
        //Création d'une liste de comptes avec 1/ CA positif 2/CA null
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account(Name = 'Account 1', Chiffre_d_affaire__c = 1000);
        Account acct2 = new Account(Name = 'Account 2', Chiffre_d_affaire__c = null);
        acctList.add(acct1);
        acctList.add(acct2);
        insert acctList;
        //Création d'un map comprenant les Id des comptes créés et la somme à ajouter au CA
        Map<Id, Decimal> acctAndCA = new Map<Id, Decimal>();
        acctAndCA.put(acct1.Id, 5000);
        acctAndCA.put(acct2.Id, 2000);
        Test.startTest();
        AccountController.updateAccountCA(acctAndCA);
        Test.stopTest();
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        //Vérifie que les Id des comptes retournés
        Assert.areEqual(acct1.Id, updatedAccounts[0].Id, 'Should return acct1 Id');
        Assert.areEqual(acct2.Id, updatedAccounts[1].Id, 'Should return acct2 Id');
        //Vérifie le nouveau montant du CA pour chaque compte
        Assert.areEqual(6000, updatedAccounts[0].Chiffre_d_affaire__c, 'Should return 6000');
        Assert.areEqual(2000, updatedAccounts[1].Chiffre_d_affaire__c, 'Should return 2000');
    }

    //Test de la méthode recalculateAccountCA
    @isTest
    static void testRecalculateAccountCA() {
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
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(1, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
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
        //Pour chaque compte de la liste de comptes, on ajoute l'Id au Set
        Set<Id> accountIds = new Set<Id>();
        for(Account acct : acctList) {
            accountIds.add(acct.Id);
        }
        Test.startTest();
        AccountController.recalculateAccountsCA(accountIds);
        Test.stopTest();
        //Récupération des Id et CA des comptes
        List<Account> acctList2 = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        //Vérification du CA du compte 1 après le recalcul (1 * 1900)
        Assert.areEqual(1900, acctList2[0].Chiffre_d_affaire__c, 'Should return 1900');
        //Vérification du CA du compte 2 après le recalcul (2 * 1900)
        Assert.areEqual(3800, acctList2[1].Chiffre_d_affaire__c, 'Should return 2800');
    }

    //Test de la méthode getAccountCA
    @isTest
    static void testGetAccountCA() {
        Account testAccount = TestDataFactory.createTestAccount1(); //Création d'un compte de test
        testAccount.Chiffre_d_affaire__c = 10000; //Ajout d'un CA
        update testAccount;
        Test.startTest();
        Decimal accountCA = AccountController.getAccountCA(testAccount.Id);
        Test.stopTest();
        //Vérification du CA récupéré par la méthode
        Assert.areEqual(10000, accountCA, 'Should return 10000');
    }
}