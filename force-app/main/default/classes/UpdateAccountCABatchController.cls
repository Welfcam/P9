public with sharing class UpdateAccountCABatchController {
    public static void runUpdateAccountCABatchController() {
        UpdateAccountCABatch newBatch = new UpdateAccountCABatch();
        Database.executeBatch(newBatch);
    }
}