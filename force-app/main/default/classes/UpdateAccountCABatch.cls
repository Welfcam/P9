global class UpdateAccountCABatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Activated'
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Activated\')');
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
        // Appeler une class qui va faire la logique du code;
        AccountController.recalculateAccountsCA(setAccountIds);
    } 
     
    global void finish(Database.BatchableContext info){     
        System.debug('Batch finished !');
    } 
}