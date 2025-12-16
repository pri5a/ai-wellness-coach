import { LightningElement, track } from 'lwc';

export default class DailyLogDashboard extends LightningElement {
    @track selectedLogId;

    handleLogSaved(event) {
        this.selectedLogId = event.detail.recordId;
    }
}