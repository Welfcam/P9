import { LightningElement, api } from 'lwc';
// TODO - récupérer la méthode apex permettant de faire ce calcul
import getSumActivatedOrdersByAccount from '@salesforce/apex/OrderController.getSumActivatedOrdersByAccount';

export default class Orders extends LightningElement {

    sumOrdersOfCurrentAccount;
    message;
    noOrder;
    error;
    @api recordId;

    connectedCallback() {
        this.fetchSumOrders();
    }

     // TODO - récupérer le montant total des Orders sur le compte avec la méthode apex
    fetchSumOrders() {
        getSumActivatedOrdersByAccount({ accountId : this.recordId })
            .then(result => {
                if(result > 0) {
                    this.sumOrdersOfCurrentAccount = result;
                    this.message = 'Total of Orders : ' + result;
                    this.noOrder = undefined;
                    this.error = undefined;
                } else {
                    this.sumOrdersOfCurrentAccount = 0;
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