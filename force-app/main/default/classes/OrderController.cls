public without sharing class OrderController {
    @AuraEnabled(Cacheable=true)
    public static Decimal getSumActivatedOrdersByAccount(Id accountId) {
        AggregateResult groupedResults = OrderSelector.getSumActivatedOrderByAccountId(accountId);
        return (Decimal)groupedResults.get('total');
    }
}