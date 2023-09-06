public with sharing class Models {

    public class QuestionnaireNameFilter{

        @AuraEnabled public String name;
        @AuraEnabled public String caseType;

        public QuestionnaireNameFilter(T_Questionnaire__c questionnaire){
            name = questionnaire.Name;
            caseType = questionnaire.Case_Type__c;
        }
    }

    public class QuestionnaireComponentFilter{

        @AuraEnabled public List<String> caseTypes;
        @AuraEnabled public List<QuestionnaireNameFilter> questionnaires;

        public QuestionnaireComponentFilter (List<T_Questionnaire__c> rawQuestionnaires, List<T_Case_Type__c> rawCaseTypes){
            List<String> types = new List <String>();
            List<QuestionnaireNameFilter> questionnairesList = new List <QuestionnaireNameFilter>();
            for (T_Questionnaire__c rawQuestionnaire : rawQuestionnaires){
                QuestionnaireNameFilter questionnaire = new Models.QuestionnaireNameFilter(rawQuestionnaire);
                questionnairesList.add(questionnaire);
            }
            for (T_Case_Type__c caseType : rawCaseTypes){
                types.add(caseType.Name);
            }
            caseTypes = types;
            questionnaires = questionnairesList;
        }
    }

    public class QuestionnaireTableRow{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String questionnaireId;
        @AuraEnabled public String caseType;

        public QuestionnaireTableRow(T_Questionnaire__c questionnaire){
            id = questionnaire.Id;
            name = questionnaire.Name;
            questionnaireId = questionnaire.Questionnaire_Id__c;
            caseType = questionnaire.Case_Type__c;
        }
    }

    public class QuestionnaireDataField{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldDataType;
        @AuraEnabled public String value;
        
        public QuestionnaireDataField(String dataRow){
            List<String> values = dataRow.split(':');
            fieldName = values[0];
            fieldDataType = values[1];
            if(fieldDataType != 'Checkbox'){
                value = values[2];
            } else {
                value = '';
            }
        }
    }

    public class QuestionnaireDemapper{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String questionnaireId;
        @AuraEnabled public String caseType;
        @AuraEnabled public List<QuestionnaireDataField> fields;
        
        public QuestionnaireDemapper(T_Questionnaire__c questionnaire) {
            id = questionnaire.Id;
            name = questionnaire.Name;
            questionnaireId = questionnaire.Questionnaire_Id__c;
            caseType = questionnaire.Case_Type__c;
            List<QuestionnaireDataField> dataFields = new List<QuestionnaireDataField>();
            String rawData = '';
            rawData += questionnaire.Fields__c == null ? '' : questionnaire.Fields__c; 
            rawData += questionnaire.Data_1__c == null ? '' : questionnaire.Data_1__c;
            rawData += questionnaire.Data_2__c == null ? '' : questionnaire.Data_2__c; 
            rawData += questionnaire.Data_3__c == null ? '' : questionnaire.Data_3__c; 
            rawData += questionnaire.Data_4__c == null ? '' : questionnaire.Data_4__c; 
            rawData += questionnaire.Data_5__c == null ? '' : questionnaire.Data_5__c; 
            rawData += questionnaire.Data_6__c == null ? '' : questionnaire.Data_6__c; 
            rawData += questionnaire.Data_7__c == null ? '' : questionnaire.Data_7__c; 
            rawData += questionnaire.Data_8__c == null ? '' : questionnaire.Data_8__c; 
            rawData += questionnaire.Data_9__c == null ? '' : questionnaire.Data_9__c; 
            rawData += questionnaire.Data_10__c == null ? '' : questionnaire.Data_10__c;
            for(String dataRow : rawData.split(';')){
                dataFields.add(new QuestionnaireDataField(dataRow));
            }
            fields = dataFields;
        }
        public QuestionnaireDemapper() {}
    }

    public class QuestionnaireJsonDemapper {

	public Integer fieldId;
	public QuestionnaireJsonDemapperValue value;
    }

    public class QuestionnaireJsonDemapperValue {
		public String fieldDataType;
		public String fieldName;
		public String value;
	}
}