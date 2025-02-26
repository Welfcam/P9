//La classe OrderSelector intéragit avec la base de données pour l'objet Order
public with sharing class OrderSelector {
    //La méthode retourne la somme des Order de chaque compte dont l'Id est passé en paramètre
    public static List<AggregateResult> getSumActivatedOrderByAccountIds(Set<Id> setAccountIds) {
        return [SELECT AccountId, SUM(TotalAmount) total FROM Order WHERE Status = 'Activated' AND AccountId IN :setAccountIds GROUP BY AccountId];
    }
}