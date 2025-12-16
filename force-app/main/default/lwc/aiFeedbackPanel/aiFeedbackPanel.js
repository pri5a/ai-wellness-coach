import { LightningElement, track, api } from 'lwc';
import generateFeedback from '@salesforce/apex/AIEngine.generateDailyFeedback';

export default class AiFeedbackPanel extends LightningElement {
    @track feedback;
    @track error;
    @api dailyLogId;

    handleGenerate() {
        this.feedback = null;
        this.error = null;

        if(!this.dailyLogId){
            this.feedback = 'Please select or save a daily log first.';
            return;
        }

        generateFeedback({ dailyLogId: this.dailyLogId })
            .then(result => {
                this.feedback = result;
            })
            .catch( err => {
                this.error = err.body?.message || err.message;
            });
    }
}