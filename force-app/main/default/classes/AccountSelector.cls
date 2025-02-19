public with sharing class AccountSelector {
    public static List<Account> getAccountsCA(Map<Id, Decimal> accountAndCA) {
        return [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountAndCA.keySet()];
    }
}