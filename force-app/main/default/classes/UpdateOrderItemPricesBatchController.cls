public with sharing class UpdateOrderItemPricesBatchController {
    public static void runUpdateOrderItemPricesBatch() {
        UpdateOrderItemPricesBatch newBatch = new UpdateOrderItemPricesBatch();
        Database.executeBatch(newBatch);
    }
}