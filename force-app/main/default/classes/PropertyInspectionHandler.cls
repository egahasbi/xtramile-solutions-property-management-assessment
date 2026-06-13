/**
 * Utility class for managing property inspection operations.
 * Includes methods for calculating average ratings,
 * retrieving overdue inspections, and updating property summaries.
 */
public with sharing class PropertyInspectionHandler {

    /**
     * Calculates the average inspection rating for a property.
     *
     * @param accountId Property Account Id
     * @return Average rating or 0 when no ratings exist
     */
    public static Decimal getAverageInspectionRating(Id accountId) {

        // Return default value when account Id is null
        if (accountId == null) {
            return 0;
        }

        // Use aggregate query to efficiently calculate average rating
        AggregateResult[] results = [
            SELECT AVG(Overall_Rating__c) avgRating
            FROM Property_Inspection__c
            WHERE Related_Property__c = :accountId
            AND Overall_Rating__c != NULL
        ];

        // Return calculated average if available
        if (!results.isEmpty() && results[0].get('avgRating') != null) {
            return (Decimal) results[0].get('avgRating');
        }

        return 0;
    }

    /**
     * Retrieves all overdue inspections.
     * An inspection is considered overdue when the inspection date
     * is before today and the status is Scheduled or In Progress.
     *
     * @return List of overdue inspections
     */
    public static List<Property_Inspection__c> getOverdueInspections() {

        // Return overdue inspections ordered by oldest date
        return [
            SELECT
                Id,
                Name,
                Inspection_Date__c,
                Inspection_Type__c,
                Inspection_Status__c,
                Overall_Rating__c,
                Related_Property__c
            FROM Property_Inspection__c
            WHERE Inspection_Date__c < :Date.today()
            AND Inspection_Status__c IN ('Scheduled', 'In Progress')
            ORDER BY Inspection_Date__c ASC
        ];
    }

    /**
     * Updates the Account description with the latest inspection summary.
     *
     * @param accountId Property Account Id
     */
    public static void updateAccountDescription(Id accountId) {

        // Exit when account Id is null
        if (accountId == null) {
            return;
        }

        // Retrieve the latest inspection record
        List<Property_Inspection__c> inspections = [
            SELECT
                Inspection_Date__c,
                Inspection_Type__c,
                Inspection_Status__c,
                Overall_Rating__c,
                Name
            FROM Property_Inspection__c
            WHERE Related_Property__c = :accountId
            ORDER BY Inspection_Date__c DESC
            LIMIT 1
        ];

        // Exit when no inspections are found
        if (inspections.isEmpty()) {
            return;
        }

        Property_Inspection__c latestInspection = inspections[0];

        String summary =
            'Latest Inspection Summary\n' +
            'Date: ' + String.valueOf(latestInspection.Inspection_Date__c) + '\n' +
            'Type: ' + latestInspection.Inspection_Type__c + '\n' +
            'Status: ' + latestInspection.Inspection_Status__c + '\n' +
            'Rating: ' + String.valueOf(latestInspection.Overall_Rating__c) + '\n' +
            'Inspector: ' + latestInspection.Name;

        // Update account description with latest inspection information
        update new Account(
            Id = accountId,
            Description = summary
        );
    }
}