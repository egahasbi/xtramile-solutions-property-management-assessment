@isTest
private class PropertyInspectionHandlerTest {
    
    @testSetup
    static void setupData() {
        
        // Create test property account
        Account acc = new Account(
            Name = 'Test Property'
        );
        insert acc;
        
        // Create test inspection records
        List<Property_Inspection__c> inspections = new List<Property_Inspection__c>{
            
            // Completed inspection with rating 5
            new Property_Inspection__c(
                Name = 'Inspector A',
                Related_Property__c = acc.Id,
                Inspection_Date__c = Date.today().addDays(-10),
                Inspection_Type__c = 'Initial',
                Inspection_Status__c = 'Completed',
                Overall_Rating__c = 5
            ),
                
                // Completed inspection with rating 4
                new Property_Inspection__c(
                    Name = 'Inspector B',
                    Related_Property__c = acc.Id,
                    Inspection_Date__c = Date.today().addDays(-5),
                    Inspection_Type__c = 'Annual',
                    Inspection_Status__c = 'Completed',
                    Overall_Rating__c = 4
                ),
                
                // Overdue inspection
                new Property_Inspection__c(
                    Name = 'Inspector C',
                    Related_Property__c = acc.Id,
                    Inspection_Date__c = Date.today().addDays(-2),
                    Inspection_Type__c = 'Maintenance',
                    Inspection_Status__c = 'Scheduled'
                )
                };
                    
                    insert inspections;
    }
    
    @isTest
    static void testGetAverageInspectionRating() {
        
        // Retrieve test account
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Test.startTest();
        
        // Execute method under test
        Decimal averageRating =
            PropertyInspectionHandler.getAverageInspectionRating(acc.Id);
        
        Test.stopTest();
        
        // Verify average rating calculation
        System.assertEquals(4.5, averageRating);
    }
    
    @isTest
    static void testGetAverageInspectionRatingWithNullAccount() {
        
        Test.startTest();
        
        // Execute method with null account Id
        Decimal averageRating =
            PropertyInspectionHandler.getAverageInspectionRating(null);
        
        Test.stopTest();
        
        // Verify default value is returned
        System.assertEquals(0, averageRating);
    }
    
    @isTest
    static void testGetOverdueInspections() {
        
        Test.startTest();
        
        // Execute method under test
        List<Property_Inspection__c> overdueInspections =
            PropertyInspectionHandler.getOverdueInspections();
        
        Test.stopTest();
        
        // Verify overdue inspections are returned
        System.assertEquals(1, overdueInspections.size());
        
        // Verify status
        System.assertEquals(
            'Scheduled',
            overdueInspections[0].Inspection_Status__c
        );
    }
    
    @isTest
    static void testUpdateAccountDescription() {
        
        // Retrieve test account
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Test.startTest();
        
        // Update account description
        PropertyInspectionHandler.updateAccountDescription(acc.Id);
        
        Test.stopTest();
        
        Account updatedAccount = [
            SELECT Description
            FROM Account
            WHERE Id = :acc.Id
        ];
        
        // Verify description is updated
        System.assertNotEquals(
            null,
            updatedAccount.Description
        );
        
        // Verify summary content exists
        System.assert(
            updatedAccount.Description.contains(
                'Latest Inspection Summary'
            )
        );
    }
    
    @isTest
    static void testUpdateAccountDescriptionWithoutInspection() {
        
        // Create account without inspection records
        Account acc = new Account(
            Name = 'Empty Property'
        );
        insert acc;
        
        Test.startTest();
        
        // Execute method under test
        PropertyInspectionHandler.updateAccountDescription(acc.Id);
        
        Test.stopTest();
        
        Account updatedAccount = [
            SELECT Description
            FROM Account
            WHERE Id = :acc.Id
        ];
        
        // Verify description remains empty
        System.assertEquals(
            null,
            updatedAccount.Description
        );
    }
    
    @isTest
    static void testGetOverdueInspectionsWithNoOverdueRecord() {
        
        // Update existing scheduled inspection to completed
        List<Property_Inspection__c> inspections = [
            SELECT Id, Inspection_Status__c, Overall_Rating__c
            FROM Property_Inspection__c
            WHERE Inspection_Status__c = 'Scheduled'
        ];
        
        for(Property_Inspection__c inspection : inspections) {
            inspection.Inspection_Status__c = 'Completed';
            inspection.Overall_Rating__c = 5;
        }
        
        update inspections;
        
        Test.startTest();
        
        List<Property_Inspection__c> overdueInspections =
            PropertyInspectionHandler.getOverdueInspections();
        
        Test.stopTest();
        
        // Verify no overdue inspections are returned
        System.assertEquals(
            0,
            overdueInspections.size()
        );
    }
    
}