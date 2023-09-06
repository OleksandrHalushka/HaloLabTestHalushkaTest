public with sharing class TestDataFactory {
    public static  List<T_Questionnaire__c>  createQuestionares() {
        Id recordTypeId = Schema.SObjectType.T_Questionnaire__c.getRecordTypeInfosByDeveloperName().get('Mapping').getRecordTypeId();
        List<T_Questionnaire__c> questionares = new List<T_Questionnaire__c>();
        T_Questionnaire__c questionareOne = new T_Questionnaire__c(
            Name = 'Sample Questionnaire',
            Questionnaire_Id__c = '123abc',
            Case_Type__c = 'Yellow',
            Fields__c = 'First_Name__c:Text:50;Last_Name__c:Long Text Area:250;Picklist__c:Picklist:Text1,Text2;Injured:Checkbox',
            recordTypeId = recordTypeId
        );

        T_Questionnaire__c questionareTwo = new T_Questionnaire__c(
            Name = 'Second Sample Questionnaire',
            Questionnaire_Id__c = '234bcd',
            Case_Type__c = 'Blue',
            Fields__c = 'First_Name__c:Text:50;Last_Name__c:Long Text Area:250;Picklist__c:Picklist:Text1,Text2;Injured:Checkbox',
            recordTypeId = recordTypeId
        );
        questionares.add(questionareOne);
        questionares.add(questionareTwo);
        insert questionares;
        return questionares;
    }

    public static List<T_Case_Type__c> createCaseTypes(){
        List<T_Case_Type__c> types = new List<T_Case_Type__c>();
        T_Case_Type__c caseTypeOne = new T_Case_Type__c(
            Name = 'Yellow'
        );
        T_Case_Type__c caseTypeTwo= new T_Case_Type__c(
            Name = 'Blue'
        );
        types.add(caseTypeOne);
        types.add(caseTypeTwo);
        insert types;
        return types;
    }
}