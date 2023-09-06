public with sharing class QuestionnaireComponentHelper {
    public static Models.QuestionnaireComponentFilter getQuestionnaireComponentFilter() {
        List<T_Case_Type__c> caseTypes = QuestionnaireComponentDatalayer.getCaseTypes();
        List<T_Questionnaire__c> questionnaires = QuestionnaireComponentDatalayer.getQuestionnaire('Name, Case_Type__c', 'WHERE RecordType.Name = \'Mapping\'');
        return new Models.QuestionnaireComponentFilter(questionnaires, caseTypes);
    }

    public static List<Models.QuestionnaireTableRow> getQuestionnaireTableRows(String name, String caseType){
        List<Models.QuestionnaireTableRow> rows = new List<Models.QuestionnaireTableRow>();
        String filters = ' WHERE ';
        filters += name != '' ? ' Name = \'' + String.escapeSingleQuotes(name) + '\' AND ' : '';
        filters += caseType != '' ? ' Case_Type__c = \'' + String.escapeSingleQuotes(caseType) + '\' AND ' : '';
        filters += 'RecordType.Name = \'Mapping\'';
        for(T_Questionnaire__c questionnaire : QuestionnaireComponentDatalayer.getQuestionnaire('Id, Name, Case_Type__c, Questionnaire_Id__c', filters)){
            Models.QuestionnaireTableRow row = new Models.QuestionnaireTableRow (questionnaire);
            rows.add(row);
        }
        return rows;
    }

    public static Models.QuestionnaireDemapper getSingleQuestionaire(String questionnaireId){
        String filters = ' WHERE ';
        filters += 'Id = \'' + questionnaireId + '\'';
        String fields = 'Id, Name, Case_Type__c, Questionnaire_Id__c, Fields__c, Data_1__c, Data_2__c, Data_3__c, Data_4__c, Data_5__c, Data_6__c, Data_7__c, Data_8__c, Data_9__c, Data_10__c';
        List<T_Questionnaire__c> questionnaireList = QuestionnaireComponentDatalayer.getQuestionnaire(fields, filters);
        if(questionnaireList.size() != 0){
            Models.QuestionnaireDemapper demapper = New Models.QuestionnaireDemapper(questionnaireList[0]);
            return demapper;
        }
        Models.QuestionnaireDemapper demapper = New Models.QuestionnaireDemapper();
        return demapper;
    }

    public static Models.QuestionnaireDemapper getSingleQuestionaireByCaseAndName(String name, String caseType){
        String fields = 'Id, Name, Case_Type__c, Questionnaire_Id__c, Fields__c, Data_1__c, Data_2__c, Data_3__c, Data_4__c, Data_5__c, Data_6__c, Data_7__c, Data_8__c, Data_9__c, Data_10__c';
        String filters = ' WHERE ';
        filters += name != '' ? ' Name = \'' + String.escapeSingleQuotes(name) + '\' AND ' : '';
        filters += caseType != '' ? ' Case_Type__c = \'' + String.escapeSingleQuotes(caseType) + '\' AND ' : '';
        filters += 'RecordType.Name = \'Mapping\'';
        List<T_Questionnaire__c> questionnaireList = QuestionnaireComponentDatalayer.getQuestionnaire(fields, filters);
        if(questionnaireList.size() != 0){
            Models.QuestionnaireDemapper demapper = New Models.QuestionnaireDemapper(questionnaireList[0]);
            return demapper;
        }
        Models.QuestionnaireDemapper demapper = New Models.QuestionnaireDemapper();
        return demapper;
    }

    public static void createUpdateQuestionaire(String name, String caseType, String id, String jsonFields){
        Id recordTypeId = Schema.SObjectType.T_Questionnaire__c.getRecordTypeInfosByDeveloperName().get('Mapping').getRecordTypeId();
        T_Questionnaire__c questionaire = new T_Questionnaire__c();
        if (name != '' && caseType != '' && id == ''){
            questionaire.Name = name;
            questionaire.Case_Type__c  = caseType;
            questionaire.Questionnaire_Id__c = name + '_' + caseType;
            questionaire.recordTypeId = recordTypeId;
        }
        if (id != ''){
            questionaire.Id = id;
        }
        Integer partOfFields = 0;
        Map<String, Decimal> sizeMap = QuestionnaireComponentHelper.getDataFieldsSize();
        List<String> fieldNames = QuestionnaireComponentHelper.getDataFieldList();
        List<String> fieldsList = QuestionnaireComponentHelper.deserializeJsonFields(jsonFields);
        for (String fieldName : fieldNames){
            Schema.DescribeSObjectResult objDescribe = questionaire.getSObjectType().getDescribe(); 
            Schema.SObjectField field = objDescribe.fields.getMap().get(fieldName);
            String fieldData = '';
            for ( Integer i = partOfFields; i < fieldsList.size(); i++ ){
                if((fieldsList[i].length() + fieldData.length() + 1) <= sizeMap.get(fieldName)){
                    fieldData += fieldsList[i] + ';';
                    partOfFields ++;
                } else {
                    break;
                }
            }
            questionaire.put(field, fieldData);
        }
        
        QuestionnaireComponentDatalayer.upsertQuestionnaire(questionaire);
    }

    private static Map<String, Decimal> getDataFieldsSize(){
        return new Map<String, Decimal>{
                'Fields__c' => Schema.SObjectType.T_Questionnaire__c.fields.Fields__c.getLength(),
                'Data_1__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_1__c.getLength(),
                'Data_2__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_2__c.getLength(),
                'Data_3__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_3__c.getLength(),
                'Data_4__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_4__c.getLength(),
                'Data_5__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_5__c.getLength(),
                'Data_6__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_6__c.getLength(),
                'Data_7__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_7__c.getLength(),
                'Data_8__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_8__c.getLength(),
                'Data_9__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_9__c.getLength(),
                'Data_10__c' => Schema.SObjectType.T_Questionnaire__c.fields.Data_10__c.getLength()
            };
        }

    private static List<String> getDataFieldList(){
        return new List<String>{'Fields__c', 'Data_1__c', 'Data_2__c', 'Data_3__c', 'Data_4__c', 'Data_5__c', 'Data_6__c', 'Data_7__c', 'Data_8__c', 'Data_9__c', 'Data_10__c'};
    }

    private static List<String> deserializeJsonFields(String jsonString){
        List<String> result = new List<String>();

        List<Models.QuestionnaireJsonDemapper> values =(List<Models.QuestionnaireJsonDemapper>) System.JSON.deserialize(jsonString, List<Models.QuestionnaireJsonDemapper>.class);
        for (Models.QuestionnaireJsonDemapper item : values) {
            String fieldName = item.value.fieldName;
            String fieldDataType = item.value.fieldDataType;
            String value = item.value.value;
            String fieldString = fieldName + ':' + fieldDataType + ':' + value;
            result.add(fieldString);
        }
        return result;
    } 
}