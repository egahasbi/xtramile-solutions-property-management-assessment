@IsTest
private class PropertyInspectionControllerTest {

    /**
     * Creates test data used by all test methods.
     */
    @TestSetup
    static void setupData() {

        // Create test account
        Account acc = new Account(
            Name = 'Test Property'
        );
        insert acc;

        // Create inspection records
        List<Property_Inspection__c> inspections = new List<Property_Inspection__c>{
            new Property_Inspection__c(
                Name = 'Inspection 1',
                Related_Property__c = acc.Id,
                Inspection_Date__c = Date.today(),
                Inspection_Type__c = 'Initial',
                Inspection_Status__c = 'Completed',
                Overall_Rating__c = 5
            ),
            new Property_Inspection__c(
                Name = 'Inspection 2',
                Related_Property__c = acc.Id,
                Inspection_Date__c = Date.today().addDays(-1),
                Inspection_Type__c = 'Annual',
                Inspection_Status__c = 'In Progress',
                Overall_Rating__c = 3
            )
        };

        insert inspections;

    }

    /**
     * Verifies retrieval without filters.
     */
    @IsTest
    static void testGetInspectionsWithoutFilters() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        List<Property_Inspection__c> inspections =
            PropertyInspectionController.getInspections(
                acc.Id,
                null,
                null
            );

        Test.stopTest();

        System.assertEquals(
            2,
            inspections.size(),
            'Two inspections should be returned.'
        );

    }

    /**
     * Verifies status filter.
     */
    @IsTest
    static void testGetInspectionsByStatus() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        List<Property_Inspection__c> inspections =
            PropertyInspectionController.getInspections(
                acc.Id,
                'Completed',
                null
            );

        Test.stopTest();

        System.assertEquals(
            1,
            inspections.size()
        );

        System.assertEquals(
            'Completed',
            inspections[0].Inspection_Status__c
        );

    }

    /**
     * Verifies type filter.
     */
    @IsTest
    static void testGetInspectionsByType() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        List<Property_Inspection__c> inspections =
            PropertyInspectionController.getInspections(
                acc.Id,
                null,
                'Initial'
            );

        Test.stopTest();

        System.assertEquals(
            1,
            inspections.size()
        );

        System.assertEquals(
            'Initial',
            inspections[0].Inspection_Type__c
        );

    }

    /**
     * Verifies both filters together.
     */
    @IsTest
    static void testGetInspectionsByStatusAndType() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        List<Property_Inspection__c> inspections =
            PropertyInspectionController.getInspections(
                acc.Id,
                'Completed',
                'Initial'
            );

        Test.stopTest();

        System.assertEquals(
            1,
            inspections.size()
        );

    }

    /**
     * Verifies average rating calculation.
     */
    @IsTest
    static void testGetAverageRating() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        Decimal averageRating =
            PropertyInspectionController.getAverageRating(
                acc.Id
            );

        Test.stopTest();

        System.assertEquals(
            4,
            averageRating,
            'Average rating should be 4.'
        );

    }

    /**
     * Verifies null account Id handling.
     */
    @IsTest
    static void testGetInspectionsWithNullAccountId() {

        Test.startTest();

        List<Property_Inspection__c> inspections =
            PropertyInspectionController.getInspections(
                null,
                null,
                null
            );

        Test.stopTest();

        System.assertEquals(
            0,
            inspections.size()
        );

    }

}