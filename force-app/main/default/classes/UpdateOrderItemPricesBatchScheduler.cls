//Le scheduler permet de planifier le batch dans Salesforce
public with sharing class UpdateOrderItemPricesBatchScheduler implements Schedulable {
    public static void execute(SchedulableContext context) {
        UpdateOrderItemPricesBatchController.runUpdateOrderItemPricesBatch();
    }
}