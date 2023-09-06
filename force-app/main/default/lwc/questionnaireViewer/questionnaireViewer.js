import { LightningElement, api } from 'lwc';
import getSingleQuestionaire from '@salesforce/apex/QuestionnaireComponentController.getSingleQuestionaire';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuestionnaireViewer extends LightningElement {
    @api recordid;
    rowsForRender = [];
    data = [];
    name;

    connectedCallback() {
        this.getData();
    }

    getData() {
        getSingleQuestionaire({ questionnaireId: this.recordid })
            .then(result => {
                this.data = result;
                let currentRowArray = [];
                let allRows = [];
                let position = 0;
                for (let item of this.data.fields) {

                    if (position <= 4 && item.fieldDataType !== 'Long Text Area') {
                        currentRowArray.push(item);
                        position += 1;
                    } else if (item.fieldDataType === 'Long Text Area') {
                        if (currentRowArray !== []) {
                            allRows.push(currentRowArray);
                            currentRowArray = [];
                        }
                        currentRowArray.push(item);
                        allRows.push(currentRowArray);
                        currentRowArray = [];
                        position = 0;
                    } else if (position === 5) {
                        allRows.push(currentRowArray);
                        currentRowArray = [];
                        currentRowArray.push(item);
                        position = 1;
                    }
                };
                if (currentRowArray !== []) {
                    allRows.push(currentRowArray);
                }
                this.rowsForRender = allRows;
                this.isData = true;
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Viever Error',
                    message: error.body.message,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('closemodal'));
    }

    get isData() {
        return !!this.rowsForRender.length;
    }
}