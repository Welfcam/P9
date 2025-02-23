public with sharing class UpdateOrderItemPricesBatchScheduler {
    public static void execute(SchedulableContext context) {
        UpdateAccountCABatchController.runUpdateAccountCABatch();
    }
}