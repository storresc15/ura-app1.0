/*********************************************************************************
Class Name      : AccsEntitlementsUtil
Description     : Util Class to provide the entitlement of the current accounts in the process - Uses Singleton Pattern
Created By      : Sebastian Torres
Created Date    : 2020-11-17
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2020-11-17                Initial version
Sebastian          2020-11-28        Added the static method to get instance as well as making the constructor private to follow the correct singleton pattern
*********************************************************************************/
public class AccsEntitlementsUtil {
  private List<Entitlement> entitlementList;
  private Map<String, Entitlement> mpAllEntitlements;

  //Static variable to hold instance of same class
  //and avoid creation of object again
  private static AccsEntitlementsUtil selfInstance = null;

  //Static method to check if its already instantiated,
  //if not then call private constructor and return
  //object
  public static AccsEntitlementsUtil getInstance(Set<Id> ids) {
    if (selfInstance == null)
      selfInstance = new AccsEntitlementsUtil(ids);
    return selfInstance;
  }

  //Private constructor to make sure no one
  //can instantiate this class
  //To be refactored in the future with the implementation of the selector class for entitlements
  private AccsEntitlementsUtil(Set<Id> ids) {
    entitlementList = [
      SELECT ID, NAME, AccountID
      FROM ENTITLEMENT
      WHERE AccountId IN :ids
    ];
    mpAllEntitlements = new Map<String, Entitlement>();
    for (Entitlement e : entitlementList) {
      mpAllEntitlements.put(e.AccountId, e);
    }
  }

  public Entitlement getEntitlement(String accId) {
    return mpAllEntitlements.get(accId);
  }

  public Boolean containsKey(String accId) {
    return mpAllEntitlements.containsKey(accId);
  }
}
