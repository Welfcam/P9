public with sharing class OrderTriggerController {
    public static void UpdateAccountCA(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {   
        //Création d'une Map pour stocker le compte et le montant total des commandes associées au compte
        Map<Id, Decimal> accountTotalMap = new Map<Id, Decimal>();
        
        //Pour chaque commande qui vient d'être activée
        for(Order order : newOrders) {
            Order oldOrder = oldOrdersMap.get(order.Id);
            if(order.Status == 'Activated' && oldOrder.Status != 'Activated') {
                //on vérifie que le compte n'est pas déjà présent et si c'est le cas on additionne le montant de la commande au montant existant
                if(accountTotalMap.containsKey(order.AccountId)) {
                    Decimal currentTotal = accountTotalMap.get(order.AccountId);
                    accountTotalMap.put(order.AccountId, currentTotal + order.TotalAmount);
                    //Sinon on ajoute le montant de la commande.
                } else {
                    accountTotalMap.put(order.AccountId, order.TotalAmount);
                }
            }
        }
        
        //Liste des comptes concernés pas les changements
        List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountTotalMap.keySet()];
        //Mise à jour du champs chiffre d'affaires pour chaque compte de la liste.
        for(Account acct : accountsToUpdate) {
            Decimal currentCA;
            if(acct.Chiffre_d_affaire__c != null) {
                currentCA = acct.Chiffre_d_affaire__c;
            } else {
                currentCA = 0;
            }
            acct.Chiffre_d_affaire__c = currentCA + accountTotalMap.get(acct.Id);
        }
        //Mise à jour des comptes
        update accountsToUpdate;
    }
}