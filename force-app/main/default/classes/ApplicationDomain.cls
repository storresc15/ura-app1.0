/*******************************************************************************
Class Name      : ApplicationDomain
Description     : Application Domain, to make easier to configure the fflib_SObjectDomain class as well as provide a means to estalish shared or common domain logic code.
Created By      : Sebastian Torres
Created Date    : 2021-09-03 
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*******************************************************************************/
/**
 * Applicaiton specific Domain base class, customise fflib_SObjectDomain and add common behaviour
 **/
public inherited sharing abstract class ApplicationDomain extends fflib_SObjectDomain {
  /**
   * Constructor required for Test.createStub
   **/
  /*public ApplicationDomain() {
        super();
    }*/

  public ApplicationDomain(List<SObject> records) {
    super(records);
    // Disable the base class CRUD checking in preference to explicit checking elsewhere
    Configuration.disableTriggerCRUDSecurity();
  }
}
