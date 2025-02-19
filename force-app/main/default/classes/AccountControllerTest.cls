@isTest
private class AccountControllerTest {

    @isTest
    static void testUpdateAccountCA() {
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account(Name = 'Account 1', Chiffre_d_affaire__c = 1000);
        Account acct2 = new Account(Name = 'Account 2', Chiffre_d_affaire__c = null);
        acctList.add(acct1);
        acctList.add(acct2);
        insert acctList;
        Map<Id, Decimal> acctAndCA = new Map<Id, Decimal>();
        acctAndCA.put(acct1.Id, 5000);
        acctAndCA.put(acct2.Id, 2000);
        Test.startTest();
        AccountController.updateAccountCA(acctAndCA);
        Test.stopTest();
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        Assert.areEqual(acct1.Id, updatedAccounts[0].Id, 'Should return acct1 Id');
        Assert.areEqual(acct2.Id, updatedAccounts[1].Id, 'Should return acct2 Id');
        Assert.areEqual(6000, updatedAccounts[0].Chiffre_d_affaire__c, 'Should return 6000');
        Assert.areEqual(2000, updatedAccounts[1].Chiffre_d_affaire__c, 'Should return 2000');
    }

    @isTest
    static void testRecalculateAccountCA() {
        Account testAccount1 = TestDataFactory.createTestAccount1();
        Account testAccount2 = TestDataFactory.createTestAccount2();
        List<Account> acctList = new List<Account>();
        acctList.add(testAccount1);
        acctList.add(testAccount2);
        List<Product2> testProductsList = TestDataFactory.createTestProductList();
        List<PricebookEntry> testPbe = TestDataFactory.createPricebookEntryList(testProductsList);
        List<Order> testOrderList1 = TestDataFactory.createTestOrderList(1, testAccount1.Id, Test.getStandardPricebookId(), 'Draft');
        List<Order> testOrderList2 = TestDataFactory.createTestOrderList(2, testAccount2.Id, Test.getStandardPricebookId(), 'Draft');
        List<OrderItem> testOrderItemList = TestDataFactory.createTestOrderItemList(testOrderList1, testPbe);
        List<OrderItem> testOrderItemList2 = TestDataFactory.createTestOrderItemList(testOrderList2, testPbe);
        testOrderList1[0].Status = 'Activated';
        testOrderList2[0].Status = 'Activated';
        testOrderList2[1].Status = 'Activated';
        update testOrderList1;
        update testOrderList2;
        Set<Id> accountIds = new Set<Id>();
        for(Account acct : acctList) {
            accountIds.add(acct.Id);
        }
        Test.startTest();
        AccountController.recalculateAccountsCA(accountIds);
        Test.stopTest();
        List<Account> acctList2 = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        Assert.areEqual(1900, acctList2[0].Chiffre_d_affaire__c, 'Should return 1900');
        Assert.areEqual(3800, acctList2[1].Chiffre_d_affaire__c, 'Should return 2800');
    }


}