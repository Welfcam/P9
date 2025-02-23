public with sharing class UpdateAccountCABatchController {
    public static void runUpdateAccountCABatch() {
        UpdateAccountCABatch newBatch = new UpdateAccountCABatch();
        Database.executeBatch(newBatch);
    }
}