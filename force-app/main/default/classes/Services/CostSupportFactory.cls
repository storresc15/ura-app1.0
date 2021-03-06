/*******************************************************************************
Class Name      : CostSupportFactory
Description     : CostSupportFactory class used as a utility class for calculating the cost of all the cases leveraging the base and decorator support and dynamic decorator via custom metadata
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class CostSupportFactory {
  //Method to be used by billing services as it gets the total costs of cases
  public static Double getTicketsCost(Set<Id> caseIds) {
    //Call the case selector class to get the case from the caseIds
    //Instantiate the selector case class
    CasesSelector selector = new CasesSelector();

    return getCost(selector.selectById(caseIds));
  }

  //Method to be used by billing services as it gets the total costs of cases
  public static Double getTicketsCost(List<Case> caseList) {
    return getCost(caseList);
  }

  private static Double getCost(List<Case> caseList) {
    Double overallTicketCost = 0;

    Map<String, Map<String, Integer>> supportMap = new Map<String, Map<String, Integer>>();

    for (case c : caseList) {
      if (!supportMap.containsKey(c.Support_Product__c)) {
        supportMap.put(c.Support_Product__c, new Map<String, Integer>());
      }
      if (
        !supportMap.get(c.Support_Product__c).containsKey(c.Support_Feature__c)
      ) {
        supportMap.get(c.Support_Product__c).put(c.Support_Feature__c, 1);
      } else {
        supportMap.get(c.Support_Product__c)
          .put(
            c.Support_Feature__c,
            supportMap.get(c.Support_Product__c).get(c.Support_Feature__c) + 1
          );
      }
    }

    system.debug('The map' + supportMap);

    for (String key : supportMap.keySet()) {
      TicketSupport baseSupport = new BaseSupport(0, key);
      for (String decoratorKey : supportMap.get(key).keySet()) {
        baseSupport = new DecoratorSupport(
          baseSupport,
          supportMap.get(key).get(decoratorKey),
          decoratorKey
        );
      }
      system.debug(
        'The overall ticket cost of this specific support' +
        key +
        ': ' +
        baseSupport.getCost()
      );
      system.debug(baseSupport.getDescription());
      overallTicketCost += baseSupport.getCost();
      system.debug(
        'The overall ticket cost at this point: ' + overallTicketCost
      );
    }

    system.debug('The final overal ticket cost is :' + overallTicketCost);
    return overallTicketCost;
  }
}
