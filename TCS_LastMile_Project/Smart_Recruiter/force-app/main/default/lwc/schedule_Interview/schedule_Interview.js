import { LightningElement, track, wire } from 'lwc';
import getCandidates from '@salesforce/apex/schedule_Interview.getCandidates';
import getOpenJobs from '@salesforce/apex/schedule_Interview.getOpenJobs';
import scheduleInterviewApex from '@salesforce/apex/schedule_Interview.scheduleInterview';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InterviewScheduler extends LightningElement {
    @track candidateId;
    @track jobId;
    @track interviewDate;
    candidateOptions = [];
    jobOptions = [];

    @wire(getCandidates)
    wiredCandidates({ data }) {
        if (data) {
            this.candidateOptions = data.map(c => ({ label: c.Name, value: c.Id }));
        }
    }

    @wire(getOpenJobs)
    wiredJobs({ data }) {
        if (data) {
            this.jobOptions = data.map(j => ({ label: j.Name, value: j.Id }));
        }
    }

    handleCandidateChange(event) {
        this.candidateId = event.detail.value;
    }
    handleJobChange(event) {
        this.jobId = event.detail.value;
    }
    handleDateChange(event) {
        this.interviewDate = event.detail.value;
    }

    scheduleInterview() {
        scheduleInterviewApex({ candidateId: this.candidateId, jobId: this.jobId, interviewDate: this.interviewDate })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Interview Scheduled!',
                    variant: 'success'
                }));
                this.candidateId = this.jobId = this.interviewDate = null;
            })
            .catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Failed to schedule interview',
                    variant: 'error'
                }));
            });
    }
}
