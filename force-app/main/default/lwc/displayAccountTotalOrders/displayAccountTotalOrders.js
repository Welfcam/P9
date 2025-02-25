import { LightningElement, api } from 'lwc';
// TODO - récupérer la méthode apex permettant de faire ce calcul
//import getSumActivatedOrdersByAccount from '@salesforce/apex/OrderController.getSumActivatedOrdersByAccount';
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

export default class DisplayAccountTotalOrders extends LightningElement {

    accountCA;
    message;
    noOrder;
    error;
    @api recordId;

    connectedCallback() {
        this.fetchSumOrders();
    }

     // TODO - récupérer le montant total des Orders sur le compte avec la méthode apex
    fetchSumOrders() {
        getAccountCA({ accountId : this.recordId })
            .then(result => {
                if(result > 0) {
                    this.accountCA = result;
                    this.message = 'Total of Orders : ' + result;
                    this.noOrder = undefined;
                    this.error = undefined;
                } else {
                    this.accountCA = 0;
                    this.noOrder = 'Error, no orders related to this account or the amount is less than zero';
                    this.message = undefined;
                    this.error = undefined;
                }
            })
            .catch(error => {
                this.error = 'An error occured while loading the total amount of orders';
                this.message = undefined;
                this.noOrder = undefined;
            })
    }
}