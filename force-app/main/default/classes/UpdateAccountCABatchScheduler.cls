public with sharing class UpdateAccountCABatchScheduler implements Schedulable {
    public static void execute(SchedulableContext context) {
        UpdateAccountCABatchController.runUpdateAccountCABatch();
    }
}