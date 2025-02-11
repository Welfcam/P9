public with sharing class OrderTriggerController {
    public static void UpdateAccountCA(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {   
        
        Map<Id, Decimal> acctAndTotalAmount = new Map<Id, Decimal>();
        
        for(Order order : newOrders) {
            Order oldOrder = oldOrdersMap.get(order.Id);
            if(order.Status == 'Activated' && oldOrder.Status != 'Activated') {
                if(acctAndTotalAmount.containsKey(order.AccountId)) {
                    Decimal currentValue = acctAndTotalAmount.get(order.AccountId);
                    currentValue = currentValue + order.TotalAmount;
                    acctAndTotalAmount.put(order.AccountId, currentValue);
                } else {
                    acctAndTotalAmount.put(order.AccountId, order.TotalAmount);
                }
            }
        }
        
        List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :acctAndTotalAmount.keySet()];
        for(Account acct : accountsToUpdate) {
            Decimal currentCA;
            if(acct.Chiffre_d_affaire__c != null) {
                currentCA = acct.Chiffre_d_affaire__c;
            } else {
                currentCA = 0;
            }
            acct.Chiffre_d_affaire__c = currentCA + acctAndTotalAmount.get(acct.Id);
        }
        update accountsToUpdate;
    }

    public static void CalculateTotalWithShipment(List<Order> newOrders) {
        for(Order order : newOrders) {
            if(order.ShipmentCost__c == null) {
                order.ShipmentCost__c = 0;
            }
            order.TotalWithShipment__c = order.TotalAmount + order.ShipmentCost__c;
        }
    }
}