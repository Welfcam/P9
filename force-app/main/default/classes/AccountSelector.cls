//La classe AccountSelector interagit avec la base de données pour l'objet Account
public with sharing class AccountSelector {
    //La méthode retourne l'Id et le CA des comptes dont l'Id est dans la Map
    public static List<Account> getAccountsCA(Map<Id, Decimal> accountAndCA) {
        return [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountAndCA.keySet()];
    }

    //La méthode retourne le CA du compte dont l'Id est passé en paramètre
    public static Decimal getAccountCA(Id acctId) {
        Account acct = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acctId];
        return acct.Chiffre_d_affaire__c;
    }
}