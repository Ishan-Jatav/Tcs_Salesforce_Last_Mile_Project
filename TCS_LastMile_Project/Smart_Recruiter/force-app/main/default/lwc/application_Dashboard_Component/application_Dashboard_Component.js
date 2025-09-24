import { LightningElement, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ChartJS from '@salesforce/resourceUrl/ChartJS';
import getApplicationsByStatus from '@salesforce/apex/Application_Dashboard_Controller.getApplicationsByStatus';

export default class Application_Dashboard_Component extends LightningElement {
    chart;
    chartData = {};
    chartInitialized = false;

    @wire(getApplicationsByStatus)
    wiredApplications({ error, data }) {
        if (data) {
            this.chartData = data;
            if (this.chartInitialized) {
                this.renderChart(); // re-render chart if Chart.js loaded
            }
        } else if (error) {
            console.error('Error fetching application data', error);
        }
    }

    renderedCallback() {
        if (this.chartInitialized) return;
        this.chartInitialized = true;

        loadScript(this, ChartJS)
            .then(() => {
                if (Object.keys(this.chartData).length > 0) {
                    this.renderChart();
                }
            })
            .catch(error => {
                console.error('Error loading ChartJS', error);
            });
    }

    renderChart() {
        const canvas = this.template.querySelector('canvas');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');

        if (this.chart) {
            this.chart.destroy();
        }

        // eslint-disable-next-line no-undef
        // eslint-disable-next-line no-undef
this.chart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: Object.keys(this.chartData),
        datasets: [{
            data: Object.values(this.chartData),
            backgroundColor: ['#36A2EB', '#FF6384', '#FFCE56', '#4CAF50']
        }]
    },
    options: {
        responsive: true,       // makes it adjust to container
        maintainAspectRatio: true, // preserves aspect ratio
        legend: { position: 'bottom' }
    }
});

    }
}
