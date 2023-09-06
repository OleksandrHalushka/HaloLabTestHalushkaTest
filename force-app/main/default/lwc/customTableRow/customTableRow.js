import { LightningElement, api } from 'lwc';

export default class CustomTableRow extends LightningElement {

    @api fieldid;
    @api value;

    fieldNameChange(event) {
        this.dispatchEvent(new CustomEvent("updatefield", { detail: { fieldid: this.fieldid, value: {fieldName: event.detail.value, fieldDataType: this.value.fieldDataType, value: this.value.value}  } }));
    }

    fieldTypeChange(event) {
        this.dispatchEvent(new CustomEvent("updatefield", { detail: { fieldid: this.fieldid, value: { fieldName: this.value.fieldName, fieldDataType: event.detail.value, value: '' } } }));
    }

    fieldValueChange(event) {
        this.dispatchEvent(new CustomEvent("updatefield", { detail: { fieldid: this.fieldid, value: {fieldName: this.value.fieldName, fieldDataType:  this.value.fieldDataType, value: event.detail.value}  } }));   
    }

    handleDelete(event) {
        this.dispatchEvent(new CustomEvent("deletefield", { detail:this.fieldid }));
    }

    get isText() {
        return this.value.fieldDataType === 'Text';
    }

    get isLongTextArea() {
        return this.value.fieldDataType === 'Long Text Area';
    }

    get isPicklist() {
        return this.value.fieldDataType === 'Picklist';
    }

    get isCheckbox() {
        return this.value.fieldDataType === 'Checkbox';
    }

    get isEnabled() {
        return (this.isCheckbox || this.isPicklist || this.isLongTextArea || this.isText);
    }

    get pickListOptions() {
        return [
            { label: 'Text', value: 'Text' },
            { label: 'Long Text Area', value: 'Long Text Area' },
            { label: 'Picklist', value: 'Picklist' },
            { label: 'Checkbox', value: 'Checkbox' }
        ]
    }
}