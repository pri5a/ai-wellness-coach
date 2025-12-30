import { LightningElement, wire } from 'lwc';
import getDailyLogs from '@salesforce/apex/DailyLogController.getDailyLogs';

export default class DailyLogList extends LightningElement {
    logs;
    error;

    @wire(getDailyLogs)
    wiredLogs({ data, error }){
        if(data){
            this.logs = data;
            this.error = null;
        } else if(error){
            this.error = error.body?.message || error.message;
        }
    }
}