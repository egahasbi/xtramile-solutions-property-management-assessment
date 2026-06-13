public with sharing class PropertyInspectionController {

    /**
     * Retrieves property inspections with optional filters.
     *
     * @param accountId Property Account Id
     * @param statusFilter Inspection status filter
     * @param typeFilter Inspection type filter
     * @return List of property inspections
     */
    @AuraEnabled(cacheable=true)
    public static List<Property_Inspection__c> getInspections(
        Id accountId,
        String statusFilter,
        String typeFilter
    ) {

        // Return empty list when account Id is null
        if (accountId == null) {
            return new List<Property_Inspection__c>();
        }

        // No filters
        if (String.isBlank(statusFilter) && String.isBlank(typeFilter)) {

            return [
                SELECT
                    Id,
                    Name,
                    Inspection_Date__c,
                    Inspection_Type__c,
                    Inspection_Status__c,
                    Overall_Rating__c
                FROM Property_Inspection__c
                WHERE Related_Property__c = :accountId
                ORDER BY Inspection_Date__c DESC
            ];
        }

        // Status filter only
        if (!String.isBlank(statusFilter) && String.isBlank(typeFilter)) {

            return [
                SELECT
                    Id,
                    Name,
                    Inspection_Date__c,
                    Inspection_Type__c,
                    Inspection_Status__c,
                    Overall_Rating__c
                FROM Property_Inspection__c
                WHERE Related_Property__c = :accountId
                AND Inspection_Status__c = :statusFilter
                ORDER BY Inspection_Date__c DESC
            ];
        }

        // Type filter only
        if (String.isBlank(statusFilter) && !String.isBlank(typeFilter)) {

            return [
                SELECT
                    Id,
                    Name,
                    Inspection_Date__c,
                    Inspection_Type__c,
                    Inspection_Status__c,
                    Overall_Rating__c
                FROM Property_Inspection__c
                WHERE Related_Property__c = :accountId
                AND Inspection_Type__c = :typeFilter
                ORDER BY Inspection_Date__c DESC
            ];
        }

        // Apply both filters
        return [
            SELECT
                Id,
                Name,
                Inspection_Date__c,
                Inspection_Type__c,
                Inspection_Status__c,
                Overall_Rating__c
            FROM Property_Inspection__c
            WHERE Related_Property__c = :accountId
            AND Inspection_Status__c = :statusFilter
            AND Inspection_Type__c = :typeFilter
            ORDER BY Inspection_Date__c DESC
        ];
    }

    /**
     * Retrieves average inspection rating for a property.
     *
     * @param accountId Property Account Id
     * @return Average inspection rating
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getAverageRating(Id accountId) {

        // Reuse business logic from handler class
        return PropertyInspectionHandler.getAverageInspectionRating(accountId);

    }

}