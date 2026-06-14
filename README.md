# Xtramile Solutions Property Management Assessment

## Overview

This project implements a Property Inspection Management solution in Salesforce. The solution includes custom object configuration, validation rules, formula fields, Apex classes, Flow automation, and a Lightning Web Component dashboard.

---

# Setup Instructions

1. Clone the repository.

2. Authorize a Salesforce org.

```bash
sf org login web
```

3. Deploy metadata.

```bash
sf project deploy start
```

4. Assign permissions if required.

5. Open the Account record page to access the Property Inspection Dashboard component.

---

# Approach to the Requirements

## Custom Object Configuration

Created a custom object named `Property_Inspection__c` to store inspection records.

Main fields include:

* Inspection Date
* Inspection Type
* Inspection Status
* Overall Rating
* Related Property

A formula field named `Days Since Inspection` calculates the number of days since the inspection date.

A validation rule ensures that completed inspections must have an Overall Rating.

---

## Apex Implementation

Created:

### PropertyInspectionHandler

Responsible for:

* Calculating average inspection ratings
* Retrieving overdue inspections
* Updating Account descriptions with the latest inspection summary

### PropertyInspectionController

Exposes methods used by the Lightning Web Component.

### Test Classes

Created:

* PropertyInspectionHandlerTest
* PropertyInspectionControllerTest

Achieved 100% code coverage for all custom Apex classes.

---

## Flow Automation

Created a Screen Flow named:

`Schedule_Property_Inspection`

The flow performs:

1. Collect inspection information.
2. Check for duplicate inspections.
3. Create a Property Inspection record.
4. Retrieve the primary contact.
5. Send an email notification.
6. Display a confirmation screen.

The flow is launched from the LWC dashboard inside a modal window.

---

## Lightning Web Component

Created:

`propertyInspectionDashboard`

Features:

* Display average rating
* Star rating visualization
* Filter by status
* Filter by inspection type
* Color-coded inspection status
* Loading indicator
* Error handling
* No records message
* Launch Flow inside a modal
* Automatically refresh data after Flow completion

---

# Assumptions Made

* Account records represent properties.
* The Account Name is used as the property name.
* Only one primary contact is used for email notification.
* Future inspection dates return 0 for the Days Since Inspection formula field.
* Overall Rating values range from 1 to 5.

---

# Known Limitations

* Email notifications are sent only to the first available contact.
* The dashboard currently supports filtering by status and inspection type only.
* Advanced reporting and analytics are outside the scope of this assessment.

---

# Screenshots

Screenshots are available in the `/screenshots` folder.

Included screenshots:

* Custom Object
* Formula Field
* Validation Rule
* List View
* Flow Canvas
* Email Notification
* Dashboard
* Filters
* Color Coding
* Modal Flow

---

# Test Execution Results

| Class                        | Coverage |
| ---------------------------- | -------- |
| PropertyInspectionHandler    | 100%     |
| PropertyInspectionController | 100%     |

Overall custom Apex coverage exceeds the required 90%.

Thank you for reviewing this submission.
