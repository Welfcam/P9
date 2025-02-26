import { LightningElement, api, wire } from 'lwc';
// TODO - récupérer la méthode apex permettant de faire ce calcul
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

export default class DisplayAccountTotalOrders extends LightningElement {

    accountCA;
    message;
    noOrder;
    error;
    @api recordId;

     // TODO - récupérer le montant total des Orders sur le compte avec la méthode apex
    @wire(getAccountCA, { accountId: '$recordId'})
    wiredAccountCA({ error, data }) {
        if (data > 0) {
            this.accountCA = data;
            this.message = 'Total of Orders : ' + data;
            this.noOrder = undefined;
            this.error = undefined;
        } else if (data = undefined || data <= 0) {
            this.noOrder = 'Error, no orders related to this account or the amount is less than zero';
            this.message = undefined;
            this.error = undefined;
        } else if(error) {
            this.error = 'An error occured while loading the total amount of orders';
            this.message = undefined;
            this.noOrder = undefined;
        }
    }
}