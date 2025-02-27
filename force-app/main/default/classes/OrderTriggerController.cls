//La classe OrderTriggerController gère les actions affectuées lors de l'activation de OrderTrigger
public with sharing class OrderTriggerController {
    //La méthode met à jour le CA des comptes lorsque qu'une order passe à Activated ou éventuellement à Draft
    public static void updateAccountCA(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {   
        //Création d'une map qui contiendra l'Id du compte et le montant à ajouter/déduire
        Map<Id, Decimal> acctAndTotalAmount = new Map<Id, Decimal>();
        //pour chaque Order qui a fait l'objet d'une mise à jour
        for(Order order : newOrders) {
            Order oldOrder = oldOrdersMap.get(order.Id);
            //Si cette mise à jour concerne le statut de l'order
            if(order.Status != oldOrder.Status) {
                //On initialise un montant de CA à considérer
                Decimal amountToConsider = 0;
                //Si le statut passe à activated
                if(order.Status == 'Activated' && oldOrder.Status != 'Activated') {
                    //on ajoute le totalAmount
                    amountToConsider = order.TotalAmount;
                    //si le statut passe à Draft (sous-entendu de Activated à draft)
                } else if(order.Status == 'Draft' && oldOrder.Status != 'Draft') {
                    //on soustrait le totalAmount
                    amountToConsider = -order.TotalAmount;
                }
                //Si le compte est déjà présent dans la Map (c'est à dire si d'autres commandes de ce compte ont changé de statut)         
                if(acctAndTotalAmount.containsKey(order.AccountId)) {
                    //On récupère le montant actuel associé au compte
                    Decimal currentValue = acctAndTotalAmount.get(order.AccountId);
                    //On ajoute le montant à considérer au montant actuel
                    currentValue = currentValue + amountToConsider;
                    //on met à jour la Map avec le nouveau CA
                    acctAndTotalAmount.put(order.AccountId, currentValue);
                } else {
                    //si le compte n'est pas déjà présent, on ajoute le montant à considérer dans la Map
                    acctAndTotalAmount.put(order.AccountId, amountToConsider);
                }
            }
        }
        //La mise à jour du CA est effectuée uniquement si la Map n'est pas vide
        if(!acctAndTotalAmount.isEmpty()) {
            AccountController.updateAccountCA(acctAndTotalAmount);
        }
    }

    //Avant la mise à jour d'une commande, la méthode calcul le totalWithShipment
    public static void calculateTotalWithShipment(List<Order> newOrders) {
        //Pour chaque commande mise à jour
        for(Order order : newOrders) {
            //Si le ShipmentCost est null, on lui donne une valeur de 0
            if(order.ShipmentCost__c == null) {
                order.ShipmentCost__c = 0;
            }
            //Le totalWithShipment correpond à la somme du totalAmount et du ShipmentCost
            order.TotalWithShipment__c = order.TotalAmount + order.ShipmentCost__c;
        }
    }
}