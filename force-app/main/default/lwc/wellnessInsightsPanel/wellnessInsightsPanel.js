import { LightningElement, track } from 'lwc';
import analyzeTrends from '@salesforce/apex/WellnessInsightService.analyzeTrends';
export default class WellnessInsightsPanel extends LightningElement {
    @track insights = [];
    @track error;

    connectedCallback() {
        analyzeTrends()
        .then(result => {
            console.log('Insights:', JSON.stringify(result));
            this.insights = result;
        })
        .catch(err => {
            console.error(err);
            this.error = err.body?.message || err.message;
        });
    }


    // @wire(analyzeTrends)
    // wiredInsights({ data, error }){
    //     if(data){
    //         console.log('data:',data);
    //      this.insights = data;
    //      this.error = undefined;   
    //     } else if(error){
    //         this.error = error.body?.message || error.message;
    //         this.insights = undefined;
    //     }
    // }
}