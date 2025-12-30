import { LightningElement, track } from 'lwc';
import analyzeTrends from '@salesforce/apex/WellnessInsightService.analyzeTrends';
export default class WellnessInsightsPanel extends LightningElement {
    @track insights = [];
    @track error;
    @track isLoading = false;

    connectedCallback() {
        this.isLoading = true;
        analyzeTrends()
        .then(result => {
            console.log('Insights:', JSON.stringify(result));
            this.insights = result;
        })
        .catch(err => {
            console.error(err);
            this.error = err.body?.message || err.message;
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
}