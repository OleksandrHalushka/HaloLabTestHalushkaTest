import { LightningElement } from 'lwc';
import getQuestionnaireTableRows from '@salesforce/apex/QuestionnaireComponentController.getQuestionnaireTableRows';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class QuestionnaireViewerEditor extends LightningElement {
    

    selectedCaseType = '';
    selectedQuestionnaireName = '';
    data;
    openedQuestionnaireId;
    isModalOpen = false;
    
        
    connectedCallback() {
        this.getData();
    }

    getData() {
        getQuestionnaireTableRows({ name: this.selectedQuestionnaireName, caseType: this.selectedCaseType })
            .then(result => {
                this.data = result;
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Questionnaire Table Error',
                    message: error.body.message,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
    }

    getFilterData(event) {
        this.selectedCaseType = event.detail.caseType;
        this.selectedQuestionnaireName = event.detail.questionnaireName;
        this.getData();
    }

    callRowAction(event) {
        this.openedQuestionnaireId = event.detail.row.id;
        const actionName = event.detail.action.name;
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.openedQuestionnaireId = '';
    }

    get columns() {
        const columns = [
            { label: 'Name', fieldName: 'name' },
            { label: 'Id', fieldName: 'questionnaireId'},
            { label: 'Case Type', fieldName: 'caseType' },
            { type: "button", label: 'View', initialWidth: 100, typeAttributes: {
            label: 'Open',
            name: 'Open',
            title: 'Open',
            disabled: false,
            value: 'open',
            variant:'base'
        }
    }
        ];
        return columns;
    }

}