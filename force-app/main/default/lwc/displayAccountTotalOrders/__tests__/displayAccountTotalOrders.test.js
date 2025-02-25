import { createElement } from 'lwc';
import DisplayAccountTotalOrders from 'c/displayAccountTotalOrders';
//Import de la méthode getAccountCA pour simuler la réponse du back end
import getAccountCA from '@salesforce/apex/AccountController.getAccountCA';

//Remplace getAccountCA par une simulation
jest.mock(
    '@salesforce/apex/AccountController.getAccountCA', 
    () => ({
        default: jest.fn()
    }), 
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
        // Simule le retour Apex avec un montant positif
        getAccountCA.mockResolvedValue(10000);

        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        document.body.appendChild(element); //ajoute l'élément au DOM

        // Attendre la fin de la promesse
        await Promise.resolve(); //1 promesse sur getAccountCA
        await Promise.resolve(); //1 promesse sur la MAJ du DOM

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_success h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('Total of Orders is : 10000');
    });

    it('Display message indicating the total amount of Account orders is <= 0', async () => {
        // Simule le retour Apex avec un montant égal à 0
        getAccountCA.mockResolvedValue(0);

        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        document.body.appendChild(element); //ajoute l'élément au DOM

        // Attendre la fin de la promesse
        await Promise.resolve(); //1 promesse sur getAccountCA
        await Promise.resolve(); //1 promesse sur la MAJ du DOM

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_error h1');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('Error, no orders related to this account or the amount is less than zero');
    });

    it('Display error message if Apex error', async () => {
        // Simule le retour Apex avec un montant égal à 0
        getAccountCA.mockRejectedValue(new Error('Apex error'));

        // Création du composant
        const element = createElement('c-displayAccountTotalOrders', { is: DisplayAccountTotalOrders });
        element.recordId = '001XXXXXXXXXXXX'; // Simule un recordId
        document.body.appendChild(element); //Ajoute l'élément au DOM

        // Attendre la fin de la promesse
        await Promise.resolve(); //1 promesse sur getAccountCA (try)
        await Promise.resolve(); //1 autre promesse sur getAccountCA ???? (catch)
        await Promise.resolve(); //1 promesse que la MAJ du DOM

        //Vérification de l'affichage dans le LWC
        const div = element.shadowRoot.querySelector('.slds-theme_error');
        expect(div).not.toBeNull();
        expect(div.textContent).toBe('An error occured while loading the total amount of orders');
    });
});