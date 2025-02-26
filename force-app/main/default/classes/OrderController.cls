//Classe de gestion de Orders. Utilise OrderSelector pour interagir avec la base de données.
public with sharing class OrderController {
    //Retourne les Id des comptes passés en paramètre avec la somme des commandes activées associées.
    public static List<AggregateResult> getSumActivatedOrdersByAccounts(Set<Id> setAccountIds) {
        List<AggregateResult> listGroupedResults = OrderSelector.getSumActivatedOrderByAccountIds(setAccountIds);
        return listGroupedResults;
    }
}