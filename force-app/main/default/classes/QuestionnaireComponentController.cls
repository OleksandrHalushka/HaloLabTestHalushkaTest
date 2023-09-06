public with sharing class QuestionnaireComponentController {

    @AuraEnabled
    public static Models.QuestionnaireComponentFilter getQuestionnaireComponentFilter(){
        try {
            return QuestionnaireComponentHelper.getQuestionnaireComponentFilter();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Models.QuestionnaireTableRow> getQuestionnaireTableRows(String name, String caseType){
        if (name == null){
            name = '';
        }
        if (caseType == null){
            caseType = '';
        }
        try {
            return QuestionnaireComponentHelper.getQuestionnaireTableRows(name, caseType);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Models.QuestionnaireDemapper getSingleQuestionaire(String questionnaireId){
        try {
            return QuestionnaireComponentHelper.getSingleQuestionaire(questionnaireId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Models.QuestionnaireDemapper getSingleQuestionaireByCaseAndName(String name, String caseType){
        if (name == null){
            name = '';
        }
        if (caseType == null){
            caseType = '';
        }
        try {
            return QuestionnaireComponentHelper.getSingleQuestionaireByCaseAndName(name, caseType);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createUpdateQuestionaire(String name, String caseType, String recordId, String jsonFields){
                if (name == null){
            name = '';
        }
        if (caseType == null){
            caseType = '';
        }
        try {
            QuestionnaireComponentHelper.createUpdateQuestionaire(name, caseType, recordId, jsonFields);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}