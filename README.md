# Xtramile Solutions Property Management Assessment

## Overview

This project implements a Property Inspection Management solution in Salesforce. The solution includes custom object configuration, validation rules, formula fields, Apex classes, Flow automation, and a Lightning Web Component dashboard.

---

# Setup Instructions

## Prerequisites

* Salesforce CLI
* Visual Studio Code with Salesforce Extension Pack
* Access to a Salesforce Developer Org

## Deploy Metadata

Authorize the target org:

```bash
sf org login web
```

Deploy the project:

```bash
sf project deploy start
```

Run Apex tests:

```bash
sf apex run test --result-format human
```

Open an Account record page to access the Property Inspection Dashboard component.

---

# Approach to the Requirements

## Custom Object Configuration

Created a custom object:

* Property_Inspection__c

Main fields include:

* Inspection Date
* Inspection Type
* Inspection Status
* Overall Rating
* Related Property

### Formula Field

Created a formula field:

**Days Since Inspection**

The formula returns:

* Number of days since the inspection date.
* Zero when the inspection date is in the future.

### Validation Rule

Created a validation rule to ensure:

* Overall Rating is required when Inspection Status is Completed.

### List View

Created an overdue inspections list view to quickly identify inspections that require attention.

---

## Apex Implementation

### PropertyInspectionHandler

Responsible for:

* Calculating average inspection ratings.
* Retrieving overdue inspections.
* Updating the Account description with the latest inspection summary.

### PropertyInspectionController

Provides methods used by the Lightning Web Component.

### Test Classes

Created:

* PropertyInspectionHandlerTest
* PropertyInspectionControllerTest

Coverage results:

| Class                        | Coverage |
| ---------------------------- | -------: |
| PropertyInspectionHandler    |      93% |
| PropertyInspectionController |     100% |

Overall code coverage exceeds the required minimum of 90%.

---

## Flow Automation

Created a Screen Flow:

### Schedule_Property_Inspection

The flow performs the following steps:

1. Collect inspection information.
2. Check for duplicate inspections.
3. Create a Property Inspection record.
4. Retrieve the primary contact.
5. Send an email notification.
6. Display a confirmation screen.

The flow is launched from the Lightning Web Component inside a modal dialog.

---

## Lightning Web Component

Created:

### propertyInspectionDashboard

Features include:

* Display average rating.
* Star rating visualization.
* Filter by inspection status.
* Filter by inspection type.
* Color-coded inspection statuses.
* Loading indicator.
* Error handling.
* No records message.
* Flow launch inside a modal window.
* Automatic refresh after flow completion.

---

# Assumptions Made

* Account records represent properties.
* Account Name is used as the property name.
* Email notifications are sent to the first available contact.
* Overall Rating values range from 1 to 5.
* Future inspection dates return zero in the Days Since Inspection formula field.

---

# Known Limitations

* Email notifications are sent only to the first available contact.
* Dashboard filters currently support status and inspection type only.
* Advanced analytics and reporting are outside the scope of this assessment.
* Duplicate checks are based on the implemented flow criteria.

---

# Screenshots of UI and Flow

The following screenshots are available in the **/screenshots** folder:

### Configuration

* Custom Object
* Custom Fields
* Formula Field
* Validation Rule
* List View

### Flow

* Flow Canvas
* Duplicate Inspection Check
* Email Notification Action

### Lightning Web Component

* Dashboard
* Filters
* Status Color Coding
* Flow Modal
* Working Functionality

---

# Test Execution Results

The following Apex test classes were executed successfully:

* PropertyInspectionHandlerTest
* PropertyInspectionControllerTest

Coverage summary:

| Apex Class                   | Coverage |
| ---------------------------- | -------: |
| PropertyInspectionHandler    |      93% |
| PropertyInspectionController |     100% |

Overall coverage exceeds the required minimum of 90%.

## Code Coverage Screenshot

![Apex Test Coverage]
(screenshots/apex-coverage1.png)
(screenshots/apex-coverage2.png)

---

Thank you for reviewing this submission.
