@isTest
private class AccountSelectorTest {
    @isTest
    static void testGetAccountsCA() {
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account(Name = 'Account 1', Chiffre_d_affaire__c = 1000);
        Account acct2 = new Account(Name = 'Account 2', Chiffre_d_affaire__c = 2000);
        acctList.add(acct1);
        acctList.add(acct2);
        insert acctList;

        Map<Id, Decimal> acctAndCA = new Map<Id, Decimal>();
        acctAndCA.put(acct1.Id, acct1.Chiffre_d_affaire__c);
        acctAndCA.put(acct2.Id, acct2.Chiffre_d_affaire__c);

        Test.startTest();
        List<Account> acctList2 = AccountSelector.getAccountsCA(acctAndCA);
        Test.stopTest();

        Assert.areEqual(2, acctList2.size(), 'Should return 2 results');
        Assert.areEqual(acct1.Id, acctList2[0].Id, 'Should return acct1 Id');
        Assert.areEqual(acct2.Chiffre_d_affaire__c, acctList2[1].Chiffre_d_affaire__c, 'Should return 2000');
    }
}