public with sharing class AccountController {
    public static void updateAccountCA(Map<Id, Decimal> acctAndCA) {
        List<Account> accountsToUpdate = AccountSelector.getAccountsCA(acctAndCA);
        for(Account acct : accountsToUpdate) {
            Decimal currentCA;
            if(acct.Chiffre_d_affaire__c != null) {
                currentCA = acct.Chiffre_d_affaire__c;
            } else {
                currentCA = 0;
            }
            acct.Chiffre_d_affaire__c = currentCA + acctAndCA.get(acct.Id);
        }
        update accountsToUpdate;
    }

    public static void recalculateAccountsCA(Set<Id> setAccountIds) {
        Map<Id, Decimal> accountCA = new Map<Id, Decimal>();
        List<AggregateResult> acctIdAndCA = OrderSelector.getSumActivatedOrderByAccountIds(setAccountIds);
        for(AggregateResult res : acctIdAndCA) {
            accountCA.put((Id) res.get('AccountId'), (Decimal) res.get('total'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId : setAccountIds) {
            Decimal acctCA = accountCA.get(accountId);
            Account acc = new Account(
                Id = accountId,
                Chiffre_d_affaire__c = acctCA
            );
            accountsToUpdate.add(acc);
        }
        update accountsToUpdate;
    }

    @AuraEnabled(Cacheable=true)
    public static Decimal getAccountCA(Id accountId) {
        return AccountSelector.getAccountCA(accountId);
    }
}