import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuestionnaireComponentFilter from '@salesforce/apex/QuestionnaireComponentController.getQuestionnaireComponentFilter';
import createUpdateQuestionaire from '@salesforce/apex/QuestionnaireComponentController.createUpdateQuestionaire';

export default class MapperCreateTab extends LightningElement {
    caseTypes = [];
    names = [];
    selectedQuestionnaireName;
    selectedCaseType = '';
    rowsForRender = [];
    questionnairesFilters;
    questionnaireNames = [];
    questionnaireNamesList = [];
    
    connectedCallback() {
        this.downloadNamesAndTypes();
    }

    downloadNamesAndTypes(event) {
        getQuestionnaireComponentFilter({})
            .then(result => {
                result.caseTypes.forEach(type => {
                    const obj = {
                        label: type,
                        value: type
                    };
                    this.caseTypes = [...this.caseTypes, obj];
                })
                this.questionnairesFilters = result.questionnaires;
                let questionnaireSet = new Set();
                this.questionnairesFilters.forEach(questionnaire => {
                    questionnaireSet.add(questionnaire.name);
                })
                questionnaireSet.forEach(name => {
                    this.questionnaireNamesList = [...this.questionnaireNamesList, { label: name, value: name }]
                })
            
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Create Tab error',
                    message: error.body.message,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
    }

    changeCaseType(event) {
        this.selectedCaseType = event.detail.value;
        let filteredNamesSet = new Set();
        this.questionnairesFilters.forEach(questionnaire => {
            if (questionnaire.caseType === event.detail.value) {
                filteredNamesSet.add(questionnaire.name);
            }
        });
        this.names = [...filteredNamesSet];
    }

    updateData(event) {
        let rowId = event.detail.fieldid;
        let newRov = event.detail.value;
        let editedRow = this.rowsForRender.find(row => row.fieldId === rowId);
        if (editedRow) {
            editedRow.value = newRov;
            this.rowsForRender = [...this.rowsForRender];
        }
    }

    deleteField(event) {
        let fieldid = event.detail;
        let newList = this.rowsForRender.slice(0, fieldid).concat(this.rowsForRender.slice(fieldid + 1));
        let index = 0;
        newList.forEach((item) => {
            item.fieldId = index;
            index++;
        })
        this.rowsForRender = [...newList];
    }

    handleNewRow(event) {
        let item = { fieldId: this.rowsForRender.length, value: { fieldName: '', fieldDataType: '', value: '' } };
        this.rowsForRender = [...this.rowsForRender, item];
    }

    handleNameInput(event) {
        this.selectedQuestionnaireName = event.detail.value;

    }

    DataCompletenessCheck() {
        this.rowsForRender.forEach((item) => {
            if (item.value.fieldName === '' || item.value.fieldDataType === '' || (item.value.value === '' && item.value.fieldDataType !== 'Checkbox')) {
                const evt = new ShowToastEvent({
                    title: 'DataCompleteness error',
                    message: 'Please, fill al fields',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
                return false;
            }
        })
        if (this.isNameAttention) {
            const evt = new ShowToastEvent({
                title: 'DataCompleteness error',
                message: 'Please select an unused name',
                variant: 'warning',
            });
            this.dispatchEvent(evt);
            return false;
        }
        if (this.selectedQuestionnaireName === '' ||  this.selectedCaseType === '') {
                        const evt = new ShowToastEvent({
                title: 'DataCompleteness error',
                message: 'Please fill name and case type',
                variant: 'warning',
            });
            this.dispatchEvent(evt);
            return false;
        }
        return true
    }

    handleCreate() {
        if (this.DataCompletenessCheck()) {
            createUpdateQuestionaire({
                name: this.selectedQuestionnaireName,
                caseType: this.selectedCaseType,
                recordId: '',
                jsonFields: JSON.stringify(this.rowsForRender)
            })
            .then(result => {
                this.selectedQuestionnaireName;
                this.selectedCaseType = '';
                this.rowsForRender = [];
                const evt = new ShowToastEvent({
                    title: 'Update Saving Success',
                    variant: 'success',
                });
                this.dispatchEvent(evt);

            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Update Saving Error',
                    message: error.body.message,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
        }
    }

    get isData() {
        return !!this.rowsForRender.length;
    }

    get isNameAttention() {
        return this.names.includes(this.selectedQuestionnaireName)
    }
}