import { LightningElement, track } from 'lwc';
import saveDailyLog from '@salesforce/apex/DailyLogController.saveDailyLog';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DailyLogForm extends LightningElement {
    @track formData = {};

    moodOptions = [
        { label: 'Good', value: 'Good' },
        { label: 'Okay', value: 'Okay' },
        { label: 'Low', value: 'Low' }
    ];

    handleChange(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    handleSave() {
        saveDailyLog({ jsonData: JSON.stringify(this.formData) })
            .then(res => {
                if(res.success) {
                    this.showToast("Success", "Daily log saved", "success");
                    this.formData = {};
                } else {
                    this.showToast("Error", res.error, "error");
                }
            })
            .catch(err => {
                this.showToast("Error", err.body?.message || err.message, "error");
            });            
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}