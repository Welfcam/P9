//Test du LWC displayAccountTotalOrders
import { createElement } from 'lwc';
import DisplayAccountTotalOrders from 'c/displayAccountTotalOrders';
//Import de la méthode getAccountCA pour la simumation du backend
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

//Création d'un mock pour simuler la réponse de getAccountCA
jest.mock(
    '@salesforce/apex/AccountController.getAccountCA', 
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            //createApexTestWireAdapter permet de simuler la réponse du backend sur un appel utilisant @wire
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

describe('c-displayAccountTotalOrders', () => {
    //Nettoyage du DOM après chaque test
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    //Test de l'affichage du LWC lorsque getAccountCA retourne un montant positif
    it('Display the total amount of Account orders if >0', async () => {
        // Création du LWC
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //Ajout l'élément au DOM
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        getAccountCA.emit(10000); //réponse simulée
        await Promise.resolve(); //attend la mise à jour du LWC
        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_success h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('Total of Orders : 10000');
    });

    //Test de l'affichage du LWC lorsque getAccountCA retourne un montant = 0
    it('Display message indicating the total amount of Account orders is <= 0', async () => {
        // Création du LWC
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //ajoute l'élément au DOM
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        getAccountCA.emit(0); //réponse simulée
        await Promise.resolve(); //attend la mise à jour du LWC
        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_shade h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('No orders related to this account or the amount is less than zero');
    });

    it('Display error message if Apex error', async () => {
        // Création du LWC
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //ajoute l'élément au DOM
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        getAccountCA.error(); //simule une erreur Apex
        await Promise.resolve(); //attend la mise à jour du LWC
        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_error h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('An error occured while loading the total amount of orders');
    });
});