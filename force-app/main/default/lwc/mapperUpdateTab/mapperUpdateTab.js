import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSingleQuestionaireByCaseAndName from '@salesforce/apex/QuestionnaireComponentController.getSingleQuestionaireByCaseAndName';
import createUpdateQuestionaire from '@salesforce/apex/QuestionnaireComponentController.createUpdateQuestionaire';

export default class MapperUpdateTab extends LightningElement {
    
    selectedQuestionnaireName;
    selectedCaseType;
    questionnaireRecordId;
    rowsForRender = [];
    visibleName;

    connectedCallback() {
        this.getData();
    }
    
    getData() {
        getSingleQuestionaireByCaseAndName({ name: this.selectedQuestionnaireName, caseType: this.selectedCaseType})
            .then(result => {
                this.rowsForRender = [];
                this.questionnaireRecordId = result.id;
                this.visibleName = result.name;
                let index = 0;
                result.fields.forEach(item =>{
                    this.rowsForRender = [...this.rowsForRender, { fieldId: index, value: item }];
                    index += 1;
                })
                })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Update Tab Error',
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
        return true
    }

    handleUpdate() {
        if (this.DataCompletenessCheck()) {
            createUpdateQuestionaire({
                name: this.selectedQuestionnaireName,
                caseType: this.selectedCaseType,
                recordId: this.questionnaireRecordId,
                jsonFields: JSON.stringify(this.rowsForRender)
            })
            .then(result => {
                const evt = new ShowToastEvent({
                    title: 'Update Saving Success',
                    variant: 'success',
                });
                this.getData();
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

}