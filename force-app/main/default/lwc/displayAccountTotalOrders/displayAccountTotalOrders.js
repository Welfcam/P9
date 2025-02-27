//Gère la logique d'affichage du LWC
import { LightningElement, api, wire } from 'lwc';
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

export default class DisplayAccountTotalOrders extends LightningElement {

    accountCA;
    message;
    noOrder;
    error;
    @api recordId;

    @wire(getAccountCA, { accountId: '$recordId'})
    wiredAccountCA({ error, data }) {
        //si getAccountCA retourne un montant positif, le montant total des Orders du compte est affiché
        if (data > 0) {
            this.accountCA = data;
            this.message = 'Total of Orders : ' + data;
            this.noOrder = undefined;
            this.error = undefined;
        //S'il est <= 0 ou undefined, un message informe l'utilisateur
        } else if (data === undefined || data <= 0) {
            this.noOrder = 'No orders related to this account or the amount is less than zero';
            this.message = undefined;
            this.error = undefined;
        //En cas d'erreur Apex, un message informe l'utilisateur
        } else if(error) {
            this.error = 'An error occured while loading the total amount of orders';
            this.message = undefined;
            this.noOrder = undefined;
        }
    }
}