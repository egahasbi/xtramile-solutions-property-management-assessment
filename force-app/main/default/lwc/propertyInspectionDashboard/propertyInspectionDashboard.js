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

                return {
                    ...inspection,
                    statusClass
                };

            });

        }
        else if (result.error) {

            console.error(result.error);

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

        window.open(
            '/flow/Schedule_Property_Inspection',
            '_blank'
        );

    }

    /**
     * Determine whether records exist
     */
    get hasInspections() {

        return this.inspections.length > 0;

    }

}