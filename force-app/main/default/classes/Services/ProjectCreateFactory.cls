/*********************************************************************************
Class Name      : ProjectCreateFactory
Description     : Factory class to create projects based on Opportunities input
Created By      : Sebastian Torres
Created Date    : 2021-10-15  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-10-15              Initial version
*********************************************************************************/
public without sharing class ProjectCreateFactory {
  public static agf__PPM_Project__c createProject(Opportunity opp) {
    agf__PPM_Project__c project = new agf__PPM_Project__c();

    /*Retrieve custom metadata from opportunity input to get values:
        Get the Project Name from  Opportunity + custom metadata
        Get Agile information --> to be defined
        Get Technologies aspects from the metadata
        Get timeline or sprints from here as well
        Consider all this information, will it require some change from the opportunity that will be created??
        
        */
    //Simple implemenation

    Project_Types__mdt projectType = Project_Types__mdt.getInstance(
      opp.Project_Type__c
    );

    Date d = opp.Planned_Start_Date__c;

    project.Name = opp.Name + ' : ' + projectType.MasterLabel;
    project.Account__c = opp.AccountId;
    project.agf__Category__c = projectType.Category__c; //Added Category
    project.agf__Delivery_Scrum_Team__c = projectType.Team__c;
    project.agf__Development_Lead__c = projectType.Lead__c;
    project.Opportunity__c = opp.id;
    project.agf__Planned_Start_Date__c = opp.Planned_Start_Date__c;
    project.agf__Planned_End_Date__c = d.addDays(
      (Integer) projectType.Project_Dates__c
    );
    project.agf__Portfolio__c = projectType.Portfolio__c;
    project.agf__Product_Owner_Project_Object__c = opp.OwnerId;
    project.agf__Project_Manager__c = projectType.Project_Manager__c;
    project.agf__Project_Summary__c = opp.Description;

    //IMPORTANT NOTE BEFORE PROCEDING: It is important to grant the access of the product owner by selecting that product owner here. Just have that clear so they can have the access to this project and consider also the access to the different US.

    return project;
  }
}
