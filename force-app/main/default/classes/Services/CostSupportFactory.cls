/*******************************************************************************
Class Name      : DecoratorSupport
Description     : Decorator support class used as a single decorator class to be used as main decorator based on custom metadata to add the price of the tickets
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class CostSupportFactory {
  public static Double getTicketsCost(Set<Id> caseIds) {
    Double overallTicketCost;

    //This method is to be developed considering the Base and Decorators Support

    //Call the case selector class to get the case from the caseIds
    List<Case> caseList = new List<Case>();

    Map<String, Map<String, Integer>> supportMap = new Map<String, Map<String, Integer>>();

    for (String key : supportMap.keySet()) {
      TicketSupport baseSupport = new BaseSupport(
        supportMap.get(key).size(),
        'Test'
      );
      //Add the method to get the cost???
      for (String decoratorKey : supportMap.get(key).keySet()) {
        TicketSupport decoratorSupport = new DecoratorSupport(
          baseSupport,
          supportMap.get(key).get(decoratorKey),
          'Test'
        );
        //Add the method to get the cost???
      }
    }

    //Get a String[] of support base and iterate over them
    //Get the Support base case based on the metadata information in the system

    //Instantiate a TicketSupport class
    //Get a String[] of decorators and iterate over them
    //follow this pattern while adding the different decorators:
    //admin = new CommunitSypport(admin,number of cases)

    return overallTicketCost;
  }
}
