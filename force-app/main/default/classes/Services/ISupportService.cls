/*******************************************************************************
Class Name      : ISupportService
Description     : Main Support Service Interface
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public interface ISupportService {
  void setSupportEntitlement(Set<Id> caseIds);
  void setCaseAssignmentRule(Set<Id> caseIds);
  void setEntitlementsAssigments(Set<Id> caseIds);
  void setEntitlementSupportOnAccount(Set<Id> accIds);
  void calculateEntitlementCases(Set<Id> accIds);
}
