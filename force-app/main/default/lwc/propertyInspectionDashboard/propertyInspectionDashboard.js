import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';

import getInspections from '@salesforce/apex/PropertyInspectionController.getInspections';
import getAverageRating from '@salesforce/apex/PropertyInspectionController.getAverageRating';

export default class PropertyInspectionDashboard extends LightningElement {

    // Current Account Id from record page
    @api recordId;

    // Store inspection records
    inspections = [];

    // Store average rating
    averageRating = 0;

    // Store selected filters
    selectedStatus = '';
    selectedType = '';

    // Store wire result for refresh
    wiredInspectionResult;

    isLoading = true;

    showFlow = false;

    /**
     * Status filter options
     */
    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Completed', value: 'Completed' },
        { label: 'Failed', value: 'Failed' }
    ];

    /**
     * Inspection type filter options
     */
    typeOptions = [
        { label: 'All', value: '' },
        { label: 'Initial', value: 'Initial' },
        { label: 'Annual', value: 'Annual' },
        { label: 'Move-Out', value: 'Move-Out' },
        { label: 'Maintenance', value: 'Maintenance' }
    ];

    /**
     * Retrieve inspection records
     */
    @wire(getInspections, {
        accountId: '$recordId',
        statusFilter: '$selectedStatus',
        typeFilter: '$selectedType'
    })
    wiredInspections(result) {

        // Save wire result for refresh
        this.wiredInspectionResult = result;

        if (result.data) {

            this.isLoading = false;

            // Add css class based on inspection status
            this.inspections = result.data.map(inspection => {

                let statusClass = '';

                if (inspection.Inspection_Status__c === 'Completed') {
                    statusClass = 'completed';
                }
                else if (inspection.Inspection_Status__c === 'In Progress') {
                    statusClass = 'inProgress';
                }
                else if (inspection.Inspection_Status__c === 'Failed') {
                    statusClass = 'failed';
                }
                else if (inspection.Inspection_Status__c === 'Scheduled') {
                    statusClass = 'scheduled';
                }

                return {
                    ...inspection,
                    statusClass
                };

            });

        }
        else if (result.error) {

            this.isLoading = false;

            this.errorMessage = 'Failed to retrieve inspection records.';

        }

    }

    /**
     * Retrieve average rating
     */
    @wire(getAverageRating, {
        accountId: '$recordId'
    })
    wiredAverageRating({ data, error }) {

        if (data) {

            this.averageRating = data;

        }
        else if (error) {

            console.error(error);

        }

    }

    /**
     * Handle status filter change
     */
    handleStatusChange(event) {

        this.selectedStatus = event.detail.value;

    }

    /**
     * Handle inspection type filter change
     */
    handleTypeChange(event) {

        this.selectedType = event.detail.value;

    }

    /**
     * Navigate user to Flow tab
     */
    handleScheduleInspection() {

        window.open('/flow/Schedule_Property_Inspection');

    }

    /**
     * Determine whether records exist
     */
    get hasInspections() {

        return this.inspections.length > 0;

    }

    get flowInputVariables() {

        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];

    }

    handleScheduleInspection() {

        // Open flow modal
        this.showFlow = true;

    }

    closeModal() {

        this.showFlow = false;

    }

    handleFlowStatusChange(event) {

        if (event.detail.status === 'FINISHED') {

            // Close modal
            this.showFlow = false;

            // Refresh inspection list
            refreshApex(this.wiredInspectionResult);

        }

    }

    

}