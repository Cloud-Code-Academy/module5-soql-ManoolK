/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Oxana Suvorova
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email 
                            FROM Lead];
        return allLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String firstName) {
        List<Contact> contacts = [
            SELECT Id, Name
            FROM Contact
            WHERE FirstName = :firstName];
        return contacts;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName(List<String> lastNames) {
        Map<Id, Contact> contactsbyId = new Map<Id, Contact>([
            SELECT Id, Name 
            FROM Contact 
            WHERE LastName IN :lastNames]);
        return new List<Id>(contactsbyId.keySet());
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunitiesByAccount(Id accountId) {
        List<Opportunity> closedWonOpps = [
            SELECT Id, Name, StageName, AccountId, CloseDate, Amount
            FROM Opportunity
            WHERE AccountId = :accountId AND StageName = 'Closed Won'];
        return closedWonOpps;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        return [SELECT Count() FROM Account];
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        Map<Id, Task> tasksById = new Map<Id, Task>([
            SELECT Id, ActivityDate, Subject
            FROM Task
            WHERE ActivityDate > TODAY AND ActivityDate <= NEXT_N_DAYS:7
        ]);
        return tasksById;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain(String emailDomain) {
        String likeDomain = '%@' + emailDomain;
        List<Contact> contacts = [
            SELECT Id, Name, Email
            FROM Contact
            WHERE Email LIKE :likeDomain
        ];
        return contacts;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String likeKeyword = '%' + keyword + '%';
        List<Opportunity> opps = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Name LIKE :likeKeyword
        ];
        return opps;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> cases = [
            SELECT Id, Origin
            FROM Case
            WHERE Origin NOT IN ('Web', 'Email', Null)
            // WHERE Origin = 'Phone'
        ];
        return cases;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        String likeKeyword = '%' + keyword + '%';
        List<Lead> leads = [
            SELECT Id, LastName, Company, Phone, Email
            FROM Lead
            WHERE LeadSource = :leadSource OR Title LIKE :likeKeyword
        ];
        return leads;
    }

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactNames = new List<String>();
        // Query the Contacts
        List<Contact> contacts = [
            SELECT Id, LastName
            FROM Contact
            WHERE AccountId = :accountId
        ];
        // Loop through each Contact and add the LastName to the list
        for (Contact cont : contacts) {
            contactNames.add(cont.LastName);
        }

        // Return the list of Contact LastNames
        return contactNames;
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        List<AggregateResult> aggrResult = [
            SELECT SUM(Amount) 
            FROM Opportunity 
            WHERE StageName = :stage OR Amount > 10000
        ];
        Decimal totalRevenue = 0;
        if (aggrResult.size() > 0) {
            totalRevenue = (Decimal) aggrResult.get(0).get('expr0');
        }
        // Return the total revenue
        return totalRevenue;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [
            SELECT Id, Name 
            FROM Account 
            ORDER BY Name ASC 
            LIMIT 10
        ];
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [
            SELECT Id, Amount, CloseDate
            FROM Opportunity 
            WHERE Amount > 100000
            ORDER BY CloseDate ASC
            Limit 5
        ];
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [
            SELECT Id, Name, Birthdate
            FROM Contact
            ORDER BY Birthdate DESC
            LIMIT 3
        ];
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [
            SELECT Id, Status, CreatedDate
            FROM Case
            WHERE Status != 'Closed'
            ORDER BY CreatedDate ASC
            LIMIT 10
            OFFSET 5
        ];
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Query the Cases and store to the Map
        Map<Id, Case> casesById = new Map<Id, Case>([
            SELECT Id FROM Case WHERE AccountId = :accountId
        ]);
        return casesById.keySet();
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        // Query the Accounts
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE BillingCountry != :country
        ];
        // Loop through each Account and add the Id and Name to the map
        for (Account acc : accounts) {
            accountIdsToNames.put(acc.Id, acc.Name);
        }
        return accountIdsToNames;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        Contact contact = [
            SELECT Id, Account.Name
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];
        return contact.Account.Name;
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getOpportunityAndAccountNamesForLineItem('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getOpportunityAndAccountNamesForLineItem(Id accountId) {
        return [
            SELECT Id, Name, (SELECT Id, Name FROM Opportunities)
            FROM Account
            WHERE id = :accountId
            LIMIT 1
        ];
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account acc = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1];
        // Store the Account's BillingState
        String billingState = acc.BillingState;
        // Query the Contacts
        List<Contact> contacts = [
            SELECT Id, Name, MailingState
            FROM Contact
            WHERE MailingState = :billingState
        ];
        return contacts;
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leads = [SELECT Email FROM Lead WHERE Id IN :leadIds AND Email != Null];
        // Create a set of email domains from the Leads
        Set<String> domains = new Set<String>();
        // Loop through each Lead
        for (Lead lead : leads) {
            domains.add('www.' + lead.Email.split('@')[1]);
        }
        // Query the Accounts
        return [
            SELECT Id, Website
            FROM Account
            WHERE Website IN :domains
        ];
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origOppLineItems = [
            SELECT Id, Name, PricebookEntryId, Quantity, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId = :origOppId
        ];
        // Create a list to hold the new line items
        List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();
        // Generate a random number between 1 and 3
        Integer randNum = (Integer)Math.floor(Math.random() * 3) + 1;
        // Loop through each cloned Opportunity Id
        for (Id oppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem origLineItem : origOppLineItems) {
                // Clone the original line item and add the random number to the quantity
                OpportunityLineItem newOppLineItem = origLineItem.clone();
                newOppLineItem.Quantity += randNum;
                newOppLineItem.OpportunityId = oppId;
                newOppLineItems.add(newOppLineItem);
            }
        }
        // Insert the new line items
        insert newOppLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {    
        return [
            SELECT Id, Name, Account.Name, Owner.Name
            FROM Opportunity
            WHERE StageName = 'Closed Won'
        ];
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opps = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : opps) {
            accIds.add(opp.AccountId);
        }
        // Query the Contacts through their Account
        List<Account> accWithContacts = [
            SELECT Id, (SELECT Id, Name FROM Contacts ORDER BY Name ASC LIMIT 1)
            FROM Account
            WHERE Id IN :accIds
        ];
        // Loop through each Account and add the Account Id and the fiest Contact Id to the map
        Map<Id, Id> contactIdByAccountId = new Map<Id, Id>();
        for (Account acc : accWithContacts) {
            contactIdByAccountId.put(acc.Id, acc.Contacts[0].Id);
        }
        // Loop through each Opportunity
        for (Opportunity opp : opps) {
            opp.Primary_Contact__c = contactIdByAccountId.get(opp.AccountId);
        }
        // Update the Opportunities
        update opps;
    }
}