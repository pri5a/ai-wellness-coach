import { LightningElement, track } from 'lwc';
import generateWeeklySummary from '@salesforce/apex/WellnessAISummaryService.generateWeeklySummary';
export default class WellnessAiSummaryPanel extends LightningElement {
    @track summary;
    @track error;

    handleGenerate(){
        this.summary = null;
        this.error = null;

        generateWeeklySummary()
        .then(result => {
            this.summary = result;
        })
        .catch(err => {
            this.error = err.body?.message || err.message;
        });
    }
}