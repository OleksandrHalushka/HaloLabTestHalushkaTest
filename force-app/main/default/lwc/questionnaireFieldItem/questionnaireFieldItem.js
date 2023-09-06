import { LightningElement,api } from 'lwc';

export default class QuestionnaireFieldItem extends LightningElement {
    
    @api fieldname;
    @api fielddatatype;
    @api value;
    selectedValue;

    changeCombobox(event){
        this.selectedValue = event.detail.value;
    }

    get isText() {
        return this.fielddatatype === 'Text'
    }

    get isLongTextArea() {
        return this.fielddatatype === 'Long Text Area'
    }
    
    get isPicklist() {
        return this.fielddatatype === 'Picklist'
    }
    
    get isCheckbox() {
        return this.fielddatatype === 'Checkbox'
    }

    get correctedFieldName() {
        let string = this.fieldname + '';
        string = string.replaceAll("__c", "");
        string = string.replaceAll("_", " ");
        return string;
    }

    get splitedValue() {
        return this.value.split(',')
    }

    get comboboxOptions() {
        let variants = [];
        if (this.isPicklist) {
            this.splitedValue.forEach((thatValue) => {
                variants = [...variants, { label: thatValue, value: thatValue }];
            });
        }

        return variants;
    }
}
