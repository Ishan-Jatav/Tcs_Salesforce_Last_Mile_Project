import { LightningElement, api, wire } from 'lwc';
import getApplicationsByJob from '@salesforce/apex/AppicationInJobPosting.getApplicationsByJob';

export default class JobApplications extends LightningElement {
    @api recordId; // Job Posting Id from record page
    applications;
    error;

    @wire(getApplicationsByJob, { jobId: '$recordId' })
    wiredApplications({ error, data }) {
        if(data) {
            this.applications = data;
            this.error = undefined;
        } else if(error) {
            this.error = error.body ? error.body.message : error;
            this.applications = undefined;
        }
    }
}
