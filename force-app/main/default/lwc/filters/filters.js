import { LightningElement} from 'lwc';
import getQuestionnaireComponentFilter from '@salesforce/apex/QuestionnaireComponentController.getQuestionnaireComponentFilter';

export default class filters extends LightningElement {
    
    caseTypes = [];
    selectedCaseType;
    questionnaireNames = [];
    selectedQuestionnaireName;
    questionnairesFilters;

    connectedCallback(){
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
                    this.questionnaireNames = [...this.questionnaireNames, { label: name, value: name }]
                })
            
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Filters error',
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
        })
        this.selectedQuestionnaireName = '';
        this.questionnaireNames = [];
        filteredNamesSet.forEach(name => {
            this.questionnaireNames = [...this.questionnaireNames, { label: name, value: name }]
        })
        this.dispatchEvent(new CustomEvent('filterchange', {detail: { caseType: this.selectedCaseType, questionnaireName: this.selectedQuestionnaireName }}));
    };

    changeQuestionnaireFilter(event){
        this.selectedQuestionnaireName = event.detail.value;
        this.dispatchEvent(new CustomEvent('filterchange', {detail: { caseType: this.selectedCaseType, questionnaireName: this.selectedQuestionnaireName }}));
    }

}