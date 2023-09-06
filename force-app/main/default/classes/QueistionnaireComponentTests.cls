@IsTest
public with sharing class  QueistionnaireComponentTests {
    @TestSetup
    static void makeData(){
        List<T_Questionnaire__c> questionares = TestDataFactory.createQuestionares();
        List<T_Case_Type__c> types = TestDataFactory.createCaseTypes();
    }

    @IsTest
    static void testGetQuestionnaireComponentFilter(){
        Test.startTest();
        Models.QuestionnaireComponentFilter filters = QuestionnaireComponentController.getQuestionnaireComponentFilter();
        Test.stopTest();
        System.assertEquals(2, filters.caseTypes.size(), 'Case types in filter');
        System.assertEquals(2, filters.questionnaires.size(), 'Questionnaire names in filter');
    }

    @IsTest
    static void testGetQuestionnaireTableRows(){
        Test.startTest();
        List<Models.QuestionnaireTableRow> rows = QuestionnaireComponentController.getQuestionnaireTableRows('Second Sample Questionnaire', 'Blue');
        Test.stopTest();
        System.assertEquals(1, rows.size(), 'Is filters work correct');
    }

    @IsTest
    static void testGetSingleQuestionaire(){
        Test.startTest();
        T_Questionnaire__c questionnaire = [SELECT Id FROM T_Questionnaire__c LIMIT 1];
        Models.QuestionnaireDemapper model = QuestionnaireComponentController.getSingleQuestionaire(questionnaire.Id);
        Test.stopTest();
        System.assertEquals(questionnaire.Id, model.id, 'Is query by id correct');
    }

    @IsTest
    static void getSingleQuestionaireByCaseAndName(){
        Test.startTest();
        Models.QuestionnaireDemapper questionnaire = QuestionnaireComponentController.getSingleQuestionaireByCaseAndName('Second Sample Questionnaire', 'Blue');
        Test.stopTest();
        System.assertEquals('Second Sample Questionnaire', questionnaire.name, 'Is name correct');
        System.assertEquals('Blue', questionnaire.caseType, 'Is case type correct');
    }

    @IsTest
    static void testCreateQuestionaire(){
        Test.startTest();
        QuestionnaireComponentController.createUpdateQuestionaire('Test version', 'Blue', null, '[{"fieldId":0,"value":{"fieldName":"Name","fieldDataType":"Text","value":"50"}},{"fieldId":1,"value":{"fieldName":"History","fieldDataType":"Long Text Area","value":"260"}}]');
        Integer count = [SELECT COUNT() FROM T_Questionnaire__c];
        Test.stopTest();
        System.assertEquals(3, count, 'Is additional questionnaire was created');
    }

    @IsTest
    static void tsetUpdateQuestionaire(){
        Test.startTest();
        T_Questionnaire__c questionnaire = [SELECT Id FROM T_Questionnaire__c LIMIT 1];
        QuestionnaireComponentController.createUpdateQuestionaire('Test version', 'Blue', questionnaire.Id, '[{"fieldId":0,"value":{"fieldName":"Name","fieldDataType":"Text","value":"50"}},{"fieldId":1,"value":{"fieldName":"History","fieldDataType":"Long Text Area","value":"260"}}]');
        Integer count = [SELECT COUNT() FROM T_Questionnaire__c];
        Test.stopTest();
        System.assertEquals(2, count, 'Is questionnaire was updated without creating new');
    }


}