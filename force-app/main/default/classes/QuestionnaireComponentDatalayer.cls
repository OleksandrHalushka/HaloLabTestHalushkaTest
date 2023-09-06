public with sharing class QuestionnaireComponentDatalayer {

    public static List<T_Case_Type__c>  getCaseTypes() {
        return [SELECT Name FROM T_Case_Type__c WITH SECURITY_ENFORCED];
    }

    public static List<T_Questionnaire__c> getQuestionnaire(String fields, String filters) {
        //Single quotes was been escaped in Helper
        String query = 'SELECT ' + String.escapeSingleQuotes(fields) + ' FROM T_Questionnaire__c ' + filters + ' WITH SECURITY_ENFORCED';
        List<T_Questionnaire__c> questionnaires = Database.query(query);
        return questionnaires;
    }

    public static void upsertQuestionnaire(T_Questionnaire__c questionnaire){
        if (Schema.sObjectType.T_Questionnaire__c.isCreateable() && Schema.sObjectType.T_Questionnaire__c.isUpdateable()){
            upsert questionnaire;
        } else {
            throw new DataLayerException('You are not authorized to make this transaction');
        }
    }

    public class DataLayerException extends Exception {}
}