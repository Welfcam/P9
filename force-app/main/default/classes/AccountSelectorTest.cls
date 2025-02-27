@isTest
private class AccountSelectorTest {
    //Test de la méthode getAccountsCA
    @isTest
    static void testGetAccountsCA() {
        //Création d'une liste de comptes avec CA
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account(Name = 'Account 1', Chiffre_d_affaire__c = 1000);
        Account acct2 = new Account(Name = 'Account 2', Chiffre_d_affaire__c = 2000);
        acctList.add(acct1);
        acctList.add(acct2);
        insert acctList;
        //Création d'une map avec L'Id et le CA de chaque compte
        Map<Id, Decimal> acctAndCA = new Map<Id, Decimal>();
        acctAndCA.put(acct1.Id, acct1.Chiffre_d_affaire__c);
        acctAndCA.put(acct2.Id, acct2.Chiffre_d_affaire__c);

        Test.startTest();
        List<Account> acctList2 = AccountSelector.getAccountsCA(acctAndCA);
        Test.stopTest();
        //Vérification du nombre de résultats retournés
        Assert.areEqual(2, acctList2.size(), 'Should return 2 results');
        //Vérification de l'Id du premier compte retourné
        Assert.areEqual(acct1.Id, acctList2[0].Id, 'Should return acct1 Id');
        //Vérification du chiffre d'affires retourné pour le 2eme compte
        Assert.areEqual(acct2.Chiffre_d_affaire__c, acctList2[1].Chiffre_d_affaire__c, 'Should return 2000');
    }

    //Test de la méthode getAccountCA
    @isTest
    static void testGetAccountCA() {
        //Création d'un compte test et ajout d'un CA
        Account testAccount = TestDataFactory.createTestAccount1();
        testAccount.Chiffre_d_affaire__c = 10000;
        update testAccount;
        Test.startTest();
        Decimal accountCA = AccountSelector.getAccountCA(testAccount.Id);
        Test.stopTest();
        //Vérification du CA retourné pour le compte.
        Assert.areEqual(10000, accountCA, 'Should return 10000');
    }
}