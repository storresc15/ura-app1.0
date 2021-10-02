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
*******************************************************************************/
public inherited sharing class SupportServiceImpl implements ISupportService {
  public void setSupportEntitlement(Set<Id> caseIds) {
    CasesSelector selector = new CasesSelector();
    List<Case> cases = selector.selectById(caseIds);
    Set<Id> contactIds = new Set<Id>();
    Set<Id> acctIds = new Set<Id>();
    Cases caseDomain = (Cases) Application.Domain.newInstance(cases);
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    for (Case c : cases) {
      contactIds.add(c.ContactId);
      acctIds.add(c.AccountId);
    }
    //At some point we should change this to use a selector class in order to retrieve the entitlements instead of calling the SOQL this way
    List<Entitlement> entls = [
      SELECT e.StartDate, e.Id, e.EndDate, e.AccountId, e.AssetId, e.CreatedDate
      FROM Entitlement e
      WHERE
        e.AccountId IN :acctIds
        AND e.EndDate >= Today
        AND e.StartDate <= Today
      ORDER BY e.CreatedDate DESC
    ];
    if (entls.isEmpty() == false) {
      for (Case c : cases) {
        if (
          c.EntitlementId == null &&
          c.AccountId != null &&
          c.Type != 'Routine Maintenance'
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

    uow.commitWork();
  }
}
