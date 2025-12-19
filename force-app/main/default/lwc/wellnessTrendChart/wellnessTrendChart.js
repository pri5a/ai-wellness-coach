import { LightningElement, track } from 'lwc';
import getLast7DaysTrends from '@salesforce/apex/WellnessTrendService.getLast7DaysTrends';
import {loadScript} from 'lightning/platformResourceLoader';
import chartJs from '@salesforce/resourceUrl/chartjs';
export default class WellnessTrendChart extends LightningElement {
    @track trendData;
    @track error;
    chartInitialized = false;

    renderedCallback(){
        if(this.chartInitialized){
            return;
        }
        this.chartInitialized = true;

        loadScript(this, chartJs + '/chart.umd.min.js')
            .then(()=> {
                console.log('Chart is loaded');
                return getLast7DaysTrends();
            })
            .then(result=>{
                this.trendData = result;
                this.renderChart();
            })
            .catch(err => {
                console.log('Error loading chartjs:', err);
                this.error = err.body?.message || err.message;
            });
    }

    renderChart(){
        const canvas = this.template.querySelector('canvas');
        console.log('canvas:', canvas);
        const ctx = canvas.getContext('2d');
        console.log('ctx:', ctx);
        const labels = this.trendData.map(d => d.logDate);
        const sleep = this.trendData.map(d => d.sleep);
        const water = this.trendData.map(d => d.water);
        const workout = this.trendData.map(d => d.workoutMinutes);

        new Chart(ctx, {
            type: 'line',
            data: {
                labels,
                datasets: [
                    { label: 'Sleep (hrs)', data: sleep, fill: false },
                    { label: 'Water (ml)', data: water, fill: false },
                    { label: 'Workout (min)', data: workout, fill: false }
                ]
            }
        });
    }
}