//Classe de gestion des Comptes Salesforce. Utilise AccountSelector pour interagir avec la base de données
public with sharing class AccountController {
    //La méthode met à jour le CA des comptes en passant dans la Map en paramètre les Ids et la somme à ajouter au CA
    //La méthode est utilisée par OrderTrigger
    public static void updateAccountCA(Map<Id, Decimal> acctAndCA) {
        //Récupère les comptes à mettre à jour
        List<Account> accountsToUpdate = AccountSelector.getAccountsCA(acctAndCA);
        //Pour chaque compte à mettre à jour : 
        for(Account acct : accountsToUpdate) {
            Decimal currentCA;
            //S'il y a un CA existant, il est utilisé
            if(acct.Chiffre_d_affaire__c != null) {
                currentCA = acct.Chiffre_d_affaire__c;
            } else {
                //S'il n'y a pas encore de CA, il est initialisé à 0
                currentCA = 0;
            }
            //Le montant indiqué dans la map est ajouté au CA
            acct.Chiffre_d_affaire__c = currentCA + acctAndCA.get(acct.Id);
        }
        //La liste de comptes est mise à jour
        update accountsToUpdate;
    }

    //La méthode recalcule le CA des comptes dont l'Id est passé en paramètre à partir des TotalAmount des Orders associées
    //Elle est utilisée dans le Batch UpdateAccountCABatch
    public static void recalculateAccountsCA(Set<Id> setAccountIds) {
        //Création d'une Map pour récupérer les comptes et les montants associés
        Map<Id, Decimal> accountCA = new Map<Id, Decimal>();
        //Récupération de la somme des Orders pour chaque compte
        List<AggregateResult> acctIdAndCA = OrderController.getSumActivatedOrdersByAccounts(setAccountIds);
        //Pour chaque résultat, on ajoute à la map L'Id du compte et la somme associée
        for(AggregateResult res : acctIdAndCA) {
            accountCA.put((Id) res.get('AccountId'), (Decimal) res.get('total'));
        }

        //Création d'un liste qui contriendra les comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        //Pour chaque Id de compte passé en paramètre
        for(Id accountId : setAccountIds) {
            //Récupération du CA total du compte dans la Map
            Decimal acctCA = accountCA.get(accountId);
            //Création d'un instance du compte avec L'Id et la mise à jour du champs chiffre d'affaires
            Account acc = new Account(
                Id = accountId,
                Chiffre_d_affaire__c = acctCA
            );
            //Ajout du compte à la liste
            accountsToUpdate.add(acc);
        }
        //Mise à jour de tous les comptes de la liste
        update accountsToUpdate;
    }

    //La méthode retourne le chiffre d'affaire d'un compte dont l'Id est passé en paramètre. Appelle le selector.
    //La méthode est utilisée dans le LWC
    @AuraEnabled(Cacheable=true)
    public static Decimal getAccountCA(Id accountId) {
        return AccountSelector.getAccountCA(accountId);
    }
}