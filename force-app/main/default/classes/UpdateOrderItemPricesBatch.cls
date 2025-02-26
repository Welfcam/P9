global class UpdateOrderItemPricesBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator('SELECT Id, UnitPrice, PricebookEntry.UnitPrice FROM OrderItem WHERE Order.Status = \'Draft\'');
    }

    global void execute(Database.BatchableContext info, List<OrderItem> scope) {
        List<OrderItem> orderItemToUpdate = new List<OrderItem>();
        for(OrderItem orderItem : scope) {
            if(orderItem.UnitPrice != orderItem.PricebookEntry.UnitPrice) {
                orderItem.UnitPrice = orderItem.PricebookEntry.UnitPrice;
                orderItemToUpdate.add(orderItem);
            }
        }
        update orderItemToUpdate;
    }

    global void finish(Database.BatchableContext info) {
        System.debug('Batch finished !');
        System.debug('CPU Time (ms): ' + Limits.getCpuTime());
    }
}
