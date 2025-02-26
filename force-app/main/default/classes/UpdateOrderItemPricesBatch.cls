//Ce Batch permet de mettre à jour les Order Item des commandes en Draft, lorsque le prix des produits à été mis à jour
global class UpdateOrderItemPricesBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info) {
        //récupère les OrderItem à mettre à jour
        return Database.getQueryLocator('SELECT Id, UnitPrice, PricebookEntry.UnitPrice FROM OrderItem WHERE Order.Status = \'Draft\'');
    }

    global void execute(Database.BatchableContext info, List<OrderItem> scope) {
        List<OrderItem> orderItemToUpdate = new List<OrderItem>();
        //Pour chaque orderItem de la liste à mettre à jour, si le prix indiqué dans le pricebook est différent du prix indiqué dans l'OrderItem
        for(OrderItem orderItem : scope) {
            if(orderItem.UnitPrice != orderItem.PricebookEntry.UnitPrice) {
                //On applique le nouveau prix
                orderItem.UnitPrice = orderItem.PricebookEntry.UnitPrice;
                orderItemToUpdate.add(orderItem);
            }
        }
        //La liste d'orderItem est mise à jour
        update orderItemToUpdate;
    }

    global void finish(Database.BatchableContext info) {
        System.debug('Batch finished !');
    }
}
