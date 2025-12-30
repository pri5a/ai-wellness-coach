import { LightningElement, track } from 'lwc';
import saveDailyLog from '@salesforce/apex/DailyLogController.saveDailyLog';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DailyLogForm extends LightningElement {
    @track formData = {};
    isLoading = false;

    moodOptions = [
        { label: 'Good', value: 'Good' },
        { label: 'Okay', value: 'Okay' },
        { label: 'Low', value: 'Low' }
    ];

    handleChange(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    // Validate required fields
    validate() {
        const dateField = this.template.querySelector('[data-field="Date__c"]');
        if(!dateField.value){
            this.showToast("Error", "Date is required", "error");
            return false;
        }
        return true;
    }

    // Save handler
    handleSave() {
        if (!this.validate()) return;
        this.isLoading = true;

        saveDailyLog({ jsonData: JSON.stringify(this.formData) })
            .then(res => {
                this.isLoading = false;

                if(res.success) {
                    this.showToast("Success", "Daily log saved", "success");

                    // Clear form
                    this.resetForm();

                    // Notify parent
                    this.dispatchEvent(new CustomEvent("logsaved", {
                        detail: {recordId: res.recordId }
                    })
                );
                } else {
                    this.showToast("Error", res.error, "error");
                }
            })
            .catch(err => {
                this.isLoading = false;
                this.showToast("Error", err.body?.message || err.message, "error");
            });            
    }

    // Reset form UI and data
    resetForm(){
        this.formData = {};

        this.template.querySelectorAll(
            'lightning-input, lightning-textarea, lightning-combobox'
        ).forEach(field => field.value = null);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}