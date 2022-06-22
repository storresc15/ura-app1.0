/*******************************************************************************
Class Name      : SupportServiceImpl
Description     : Main Support Service Implementation
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version

Sebastian                 2021-10-07              Refactor the Service by implementing a facade pattern to group the entitlement and assignment rule methods together
Sebastian                 2021-10-14              Added the set entitlement method for the accounts as the SLA changes
*******************************************************************************/
public without sharing class SupportServiceImpl implements ISupportService {
  public void setSupportEntitlement(Set<Id> caseIds) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    setSupportEntitlement(caseIds, uow);
    uow.commitWork();
  }

  public void setSupportEntitlement(
    Set<Id> caseIds,
    fflib_ISObjectUnitOfWork uow
  ) {
    CasesSelector selector = (CasesSelector) Application.Selector.newInstance(
      Case.SObjectType
    );
    EntitlementsSelector entSelector = (EntitlementsSelector) Application.Selector.newInstance(
      Entitlement.SObjectType
    );
    List<Case> cases = selector.selectById(caseIds);
    Set<Id> contactIds = new Set<Id>();
    Set<Id> acctIds = new Set<Id>();
    Cases caseDomain = (Cases) Application.Domain.newInstance(cases);
    for (Case c : cases) {
      contactIds.add(c.ContactId);
      acctIds.add(c.AccountId);
    }
    //At some point we should change this to use a selector class in order to retrieve the entitlements instead of calling the SOQL this way
    List<Entitlement> entls = entSelector.selectFromAccountIds(acctIds);
    system.debug('Inside the Impl class, the cases: ' + cases);
    system.debug('Inside the Impl class, the entitlements: ' + entls);
    if (entls == null || entls.isEmpty() == false) {
      assignEntitlement(cases, entls, caseDomain, uow);
    }
  }

  public void setCaseAssignmentRule(Set<Id> caseIds) {
    MyDML dmlOptions = new MyDML();
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      dmlOptions
    );

    setCaseAssignmentRule(caseIds, uow, dmlOptions);

    uow.commitWork();
  }

  //Overloading the previous method to accept also a uow parameter
  public void setCaseAssignmentRule(
    Set<Id> caseIds,
    fflib_ISObjectUnitOfWork uow,
    MyDML dmlOptions
  ) {
    CasesSelector selector = (CasesSelector) Application.Selector.newInstance(
      Case.SObjectType
    );
    List<Case> cases = selector.selectById(caseIds);

    for (Case c : cases) {
      system.debug(
        'Inside the SupportService -- processing this case: ' + c.id
      );
      //Database.DMLOptions dmlOpts = new Database.DMLOptions();
      //dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
      //dmlOpts.assignmentRuleHeader.useDefaultRule = true;
      //Setting the DMLOption on Case instance
      System.debug(
        'This case ' +
        c.Id +
        ' --> Is added with these options: ' +
        dmlOptions.getDMLOptions()
      );
      c.setOptions(dmlOptions.getDMLOptions());
      uow.registerDirty(c);
    }
  }

  //This method is used as facade pattern to call both the Entitlement and Assignment methods within a single call
  public void setEntitlementsAssigments(Set<Id> caseIds) {
    //Get configuration for the uow and DML opperations
    MyDML dmlOptions = new MyDML();
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      dmlOptions
    );

    //Call the methods with a single uow and dml options
    setSupportEntitlement(caseIds, uow);
    setCaseAssignmentRule(caseIds, uow, dmlOptions);

    //Commit work from the methods called
    uow.commitWork();
  }

  //Method to automatically create an entitlement on Account
  public void setEntitlementSupportOnAccount(Set<Id> accIds) {
    //Instance of unit of work for updates
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    //Call the utils class to get the entitlements form account
    AccsEntitlementsUtil util = AccsEntitlementsUtil.getInstance(accIds);
    BusinessHours bhs = [
      SELECT id
      FROM BusinessHours
      WHERE IsDefault = TRUE
      LIMIT 1
    ];
    //Retrieve the account from selector
    AccountsSelector selector = (AccountsSelector) Application.Selector.newInstance(
      Account.SObjectType
    );
    List<Account> accs = selector.selectAccountWithCasesAndEntitlements(accIds);

    //Check if the Account already has an active entitlment
    for (Account a : accs) {
      if (util.containsKey(a.id))
        uow.registerDeleted(util.getEntitlement(a.id));
      AdminSupportFactory.SupportDetails support = AdminSupportFactory.getSupportDetails(
        a.SLA__c
      );
      //Throwing Exception if no support is found
      if (support == null) {
        throw new Application.URAAppException(
          'No SLA could be found for ' +
          a.SLA__c +
          '. So we were not able to process a new entitlement for this account: ' +
          a.id
        );
      }

      Entitlement e = new Entitlement(
        Name = a.SLA__C + ' : ' + a.Name,
        AccountId = a.Id,
        SlaProcessId = support.EntitlementProcess,
        IsPerIncident = true,
        CasesPerEntitlement = (Integer) support.AllowedTickets,
        RemainingCases = (Integer) support.AllowedTickets,
        BusinessHoursId = bhs.id,
        StartDate = Date.today(),
        EndDate = Date.today() + 365
        //Status = Active
      );
      uow.registerNew(e);

      //Check if this code works without the actual update on the field
      for (Case c : a.cases) {
        uow.registerDirty(c, case.EntitlementId, e);
      }
    }
    //Commit the work
    uow.commitWork();
  }

  //Method to calculate the remaining cases in Entitlment
  //TO BE REVIEWED IN FUTURE
  public void calculateEntitlementCases(Set<Id> accIds) {
    AccountsSelector selector = (AccountsSelector) Application.Selector.newInstance(
      Account.SObjectType
    );
    List<Account> accs = selector.selectAccountWithCasesAndEntitlements(accIds);
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    system.debug('Inside the calculate entitlement with Accounts: ' + accs);
    for (Account a : accs) {
      system.debug(
        'Starting with Account: ' +
        a.Name +
        'With these entitlements: ' +
        a.Entitlements
      );
      for (Entitlement e : a.Entitlements) {
        system.debug(
          'Inside the calculate entitlement For entitlement: ' + e.Name
        );
        integer count = 0;
        for (Case c : a.Cases) {
          if (c.Status == 'Closed' && c.EntitlementId == e.Id) {
            count++;
          }
        }

        e.RemainingCases = e.CasesPerEntitlement - count;
        system.debug(
          'Inside the calculate entitlement Updating entitlement ' +
          e.Name +
          'with: ' +
          e.RemainingCases
        );
        uow.registerDirty(e);
      }
    }
    uow.commitWork();
  }

  @TestVisible
  private void assignEntitlement(
    List<Case> cases,
    List<Entitlement> entls,
    Cases caseDomain,
    fflib_ISObjectUnitOfWork uow
  ) {
    for (Case c : cases) {
      system.debug(
        'Inside the assignEntitlement Method in service for following case: ' +
        c
      );
      if (
        c.EntitlementId == null &&
        c.AccountId != null /*&&
         c.Type != 'Routine Maintenance' Why we need this??*/
      ) {
        for (Entitlement e : entls) {
          if (e.AccountId == c.AccountId) {
            caseDomain.assignEntitlement(c, e.id, uow);
            break;
          }
        }
      }
    }
  }
}
