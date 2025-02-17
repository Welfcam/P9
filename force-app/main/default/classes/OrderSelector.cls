public with sharing class OrderSelector {
    public static AggregateResult getSumActivatedOrderByAccountId(Id accountId) {
        return [SELECT SUM(TotalAmount) total FROM Order WHERE AccountId = :accountId AND Status = 'Activated'];
    }
}