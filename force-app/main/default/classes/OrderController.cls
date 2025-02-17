public without sharing class OrderController {
    
    // TODO - Corriger l'erreur ici, nous retournons le montant TOTAL de tous les "Orders" 
    // mais nous souhaitons retourner le montant TOTAL des orders  aux status = 'Activated' du compte sur lequel le composant LWC se situe
    @AuraEnabled(Cacheable=true)
    public static Decimal getSumActivatedOrdersByAccount(Id accountId) {
        AggregateResult groupedResults = OrderSelector.getSumActivatedOrderByAccountId(accountId);
        return (Decimal)groupedResults.get('total');
    }
}