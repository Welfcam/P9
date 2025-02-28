public with sharing class OrderTriggerController {
    public static void updateAccountCA(List<Order> newOrders, Map<Id, Order> oldOrdersMap) {   
        Map<Id, Decimal> acctAndTotalAmount = new Map<Id, Decimal>();
        for(Order order : newOrders) {
            Order oldOrder = oldOrdersMap.get(order.Id);
            if(order.Status != oldOrder.Status) {
                Decimal amountToConsider = 0;
                if(order.Status == 'Activated' && oldOrder.Status != 'Activated') {
                    amountToConsider = order.TotalAmount;
                } else if(order.Status == 'Draft' && oldOrder.Status != 'Draft') {
                    amountToConsider = -order.TotalAmount;
                }
                if(acctAndTotalAmount.containsKey(order.AccountId)) {
                    Decimal currentValue = acctAndTotalAmount.get(order.AccountId);
                    currentValue = currentValue + amountToConsider;
                    acctAndTotalAmount.put(order.AccountId, currentValue);
                } else {
                    acctAndTotalAmount.put(order.AccountId, amountToConsider);
                }
            }
        }
        if(!acctAndTotalAmount.isEmpty()) {
            AccountController.updateAccountCA(acctAndTotalAmount);
        }
    }

    public static void calculateTotalWithShipment(List<Order> newOrders) {
        for(Order order : newOrders) {
            if(order.ShipmentCost__c == null) {
                order.ShipmentCost__c = 0;
            }
            order.TotalWithShipment__c = order.TotalAmount + order.ShipmentCost__c;
        }
    }
}