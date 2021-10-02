/*******************************************************************************
Class Name      : Cases
Description     : Main Domain class for Case Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
-------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*******************************************************************************/
public inherited sharing class Cases extends ApplicationDomain {
  public Cases(List<Case> cases) {
    super(cases);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public void assignEntitlement(
    Case c,
    Id entitlementId,
    fflib_ISObjectUnitOfWork uow
  ) {
    c.EntitlementId = entitlementId;
    uow.registerDirty(c);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Cases(sObjectList);
    }
  }
}
