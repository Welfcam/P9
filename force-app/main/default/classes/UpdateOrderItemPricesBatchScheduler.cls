public with sharing class UpdateOrderItemPricesBatchScheduler implements Schedulable {
    public static void execute(SchedulableContext context) {
        UpdateOrderItemPricesBatchController.runUpdateOrderItemPricesBatch();
    }
}