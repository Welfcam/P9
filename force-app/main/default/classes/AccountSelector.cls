public with sharing class AccountSelector {
    public static List<Account> getAccountsCA(Map<Id, Decimal> accountAndCA) {
        return [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountAndCA.keySet()];
    }

    public static Decimal getAccountCA(Id accountId) {
        Account acct = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :accountId];
        return acct.Chiffre_d_affaire__c;
    }
}