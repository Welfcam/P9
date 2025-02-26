import { createElement } from 'lwc';
import DisplayAccountTotalOrders from 'c/displayAccountTotalOrders';
//Import de la méthode getAccountCA pour simuler la réponse du back end
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

jest.mock(
    '@salesforce/apex/AccountController.getAccountCA', 
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

//Tests du LWC
describe('c-displayAccountTotalOrders', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('Display the total amount of Account orders if >0', async () => {
    
        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //ajoute l'élément au DOM
        
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        
        getAccountCA.emit(10000);

        await Promise.resolve();

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_success h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('Total of Orders : 10000');
    });

    it('Display message indicating the total amount of Account orders is <= 0', async () => {
        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //ajoute l'élément au DOM
        
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId

        getAccountCA.emit(0);

        await Promise.resolve();

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_shade h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('Error, no orders related to this account or the amount is less than zero');
    });

    it('Display error message if Apex error', async () => {
        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        document.body.appendChild(element); //ajoute l'élément au DOM
        
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId

        getAccountCA.error();

        await Promise.resolve();

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_error h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('An error occured while loading the total amount of orders');
    });
});