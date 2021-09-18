/*******************************************************************************
Class Name      : DecoratorSupport
Description     : Decorator support class used as a single decorator class to be used as main decorator based on custom metadata to add the price of the tickets this class uses a new approach of dynamic decorator that uses the different metadata types
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
    Double overallTicketCost = 0;

    //Call the case selector class to get the case from the caseIds
    Map<String, Map<String, Integer>> supportMap = new Map<String, Map<String, Integer>>();
    //Instantiate the selector case class
    CasesSelector selector = new CasesSelector();

    for (case c : selector.selectById(caseIds)) {
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
