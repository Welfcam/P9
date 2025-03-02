//Cette classe gère les actions effectuées au déclenchement du trigger sur Order
public with sharing class OrderTriggerController {
    public static void updateAccountCA(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {   
        //Création d'une map pour contenir l'Id du compte et le montant à ajouter/déduire du CA
        Map<Id, Decimal> acctAndTotalAmount = new Map<Id, Decimal>();
        //Pour chaque Order qui a fait l'objet d'une mise à jour
        for(Order order : newOrders) {
            Order oldOrder = oldOrdersMap.get(order.Id);
            //Si cette mise à jour concerne le statut de l'order
            if(order.Status != oldOrder.Status) {
                //Le montant à considérer est initialisé à 0
                Decimal amountToConsider = 0;
                //Si le statut passe à Activated
                if(order.Status == 'Activated' && oldOrder.Status != 'Activated') {
                    //le montant à considérer correspond au TotalAmount de l'order (montant à ajouter)
                    amountToConsider = order.TotalAmount;
                //Si le statut passe à Draft    
                } else if(order.Status == 'Draft' && oldOrder.Status != 'Draft') {
                    //le montant à considérer correspond à l'opposé du TotalAmount de l'order (montant à déduire)
                    amountToConsider = -order.TotalAmount;
                }
                //Si le compte est déjà présent dans la Map (cad si 'autres commandes du même compte ont changé de statut')
                if(acctAndTotalAmount.containsKey(order.AccountId)) {
                    //on récupère le montant actuel associé au compte
                    Decimal currentValue = acctAndTotalAmount.get(order.AccountId);
                    //On ajoute le motant à considérer
                    currentValue = currentValue + amountToConsider;
                    //On met à jour la Map avec le nouveau montant
                    acctAndTotalAmount.put(order.AccountId, currentValue);
                } else {
                    //Si le compte n'est pas déjà présent, on le montant à considérer dans la Map
                    acctAndTotalAmount.put(order.AccountId, amountToConsider);
                }
            }
        }
        //La mise à jour du CA est effectuée uniquement si la Map n'est pas vide
        if(!acctAndTotalAmount.isEmpty()) {
            AccountController.updateAccountCA(acctAndTotalAmount);
        }
    }

    //Mise à jour du champ TotalWithShipment
    public static void calculateTotalWithShipment(List<Order> newOrders) {
        //Pour chaque commande mise à jour
        for(Order order : newOrders) {
            //Si le ShipmentCost est null, on le cosidère à 0
            if(order.ShipmentCost__c == null) {
                order.ShipmentCost__c = 0;
            }
            //Le totalWithShipment est calculé
            order.TotalWithShipment__c = order.TotalAmount + order.ShipmentCost__c;
        }
    }
}