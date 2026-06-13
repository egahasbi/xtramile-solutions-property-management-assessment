import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';

import getInspections from '@salesforce/apex/PropertyInspectionController.getInspections';
import getAverageRating from '@salesforce/apex/PropertyInspectionController.getAverageRating';

export default class PropertyInspectionDashboard extends LightningElement {

    // Current Account Id from record page
    @api recordId;

    // Store inspection records
    inspections = [];

    // Store average rating value
    averageRating = 0;

    // Store selected filters
    selectedStatus = '';
    selectedType = '';

    // Store wire result for refresh
    wiredInspectionResult;

    // Store error message
    errorMessage;

    // Control loading spinner visibility
    isLoading = true;

    // Control flow modal visibility
    showFlow = false;

    /**
     * Status filter options.
     */
    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Completed', value: 'Completed' },
        { label: 'Failed', value: 'Failed' }
    ];

    /**
     * Inspection type filter options.
     */
    typeOptions = [
        { label: 'All', value: '' },
        { label: 'Initial', value: 'Initial' },
        { label: 'Annual', value: 'Annual' },
        { label: 'Move-Out', value: 'Move-Out' },
        { label: 'Maintenance', value: 'Maintenance' }
    ];

    /**
     * Retrieves inspection records based on selected filters.
     */
    @wire(getInspections, {
        accountId: '$recordId',
        statusFilter: '$selectedStatus',
        typeFilter: '$selectedType'
    })
    wiredInspections(result) {

        // Save wire result for future refresh
        this.wiredInspectionResult = result;

        if (result.data) {

            this.isLoading = false;
            this.errorMessage = undefined;

            // Add status css class and rating stars
            this.inspections = result.data.map(inspection => {

                let statusClass = 'scheduled';

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
                    statusClass,
                    ratingStars:
                        inspection.Overall_Rating__c
                            ? '⭐'.repeat(inspection.Overall_Rating__c)
                            : 'N/A'
                };

            });

        }
        else if (result.error) {

            this.isLoading = false;
            this.errorMessage = 'Failed to retrieve inspection records.';

        }

    }

    /**
     * Retrieves average inspection rating.
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
     * Returns formatted average rating.
     */
    get averageRatingDisplay() {

        return this.averageRating
            ? this.averageRating.toFixed(1)
            : 'N/A';

    }

    /**
     * Returns star icons for average rating.
     */
    get averageStars() {

        const stars = [];
        const roundedRating = Math.round(this.averageRating);

        for (let i = 1; i <= 5; i++) {

            stars.push({
                index: i,
                className:
                    i <= roundedRating
                        ? 'star-filled'
                        : 'star-empty'
            });

        }

        return stars;

    }

    /**
     * Determines whether inspections exist.
     */
    get hasInspections() {

        return this.inspections.length > 0;

    }

    /**
     * Returns input variables for Flow.
     */
    get flowInputVariables() {

        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];

    }

    /**
     * Handles status filter changes.
     */
    handleStatusChange(event) {

        this.selectedStatus = event.detail.value;

    }

    /**
     * Handles inspection type filter changes.
     */
    handleTypeChange(event) {

        this.selectedType = event.detail.value;

    }

    /**
     * Opens flow modal.
     */
    handleScheduleInspection() {

        this.showFlow = true;

    }

    /**
     * Closes flow modal.
     */
    closeModal() {

        this.showFlow = false;

    }

    /**
     * Handles flow completion and refreshes inspection list.
     */
    handleFlowStatusChange(event) {

        if (event.detail.status === 'FINISHED') {

            // Close modal
            this.showFlow = false;

            // Refresh inspection records
            refreshApex(this.wiredInspectionResult);

        }

    }

}