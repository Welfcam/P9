public with sharing class OrderSelector {
    public static AggregateResult getSumActivatedOrderByAccountId(Id accountId) {
        return [SELECT SUM(TotalAmount) total FROM Order WHERE AccountId = :accountId AND Status = 'Activated'];
    }

    public static List<AggregateResult> getSumActivatedOrderByAccountIds(Set<Id> setAccountIds) {
        return [SELECT AccountId, SUM(TotalAmount) total FROM Order WHERE Status = 'Activated' AND AccountId IN :setAccountIds GROUP BY AccountId];
    }
}