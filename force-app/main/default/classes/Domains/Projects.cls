/*********************************************************************************
Class Name      : Projects
Description     : Main Domain class for Project Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Projects extends ApplicationDomain {
  public Projects(List<agf__PPM_Project__c> projects) {
    super(projects);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
    /*ProjectsService.handleProjectsAccessToUsers(getQualifiedProjectsforUserGrantAccess((List<agf__PPM_Project__c>) Records,
     existingRecords));*/
    getQualifiedProjectsforUserGrantAccess(
      (List<agf__PPM_Project__c>) Records,
      existingRecords
    );
  }

  public void getQualifiedProjectsforUserGrantAccess(
    List<agf__PPM_Project__c> Records,
    Map<Id, sObject> existingRecords
  ) {
    List<AsyncRequest__c> newAsyncRequests = new List<AsyncRequest__c>();

    List<String> textChangedIds = new List<ID>();

    Map<Id, agf__PPM_Project__c> projectsOldMap = new Map<ID, agf__PPM_Project__c>(
      (List<agf__PPM_Project__c>) existingRecords.values()
    );
    Set<Id> projectIds = new Set<Id>();

    for (agf__PPM_Project__c project : Records) {
      if (project.Active__c != projectsOldMap.get(project.id).Active__c) {
        textChangedIds.add(project.Id);
        if (textChangedIds.size() > 100) {
          newAsyncRequests.add(
            new AsyncRequest__c(
              AsyncType__c = 'HandleUserPermission',
              Params__c = string.Join(textChangedIds, ',')
            )
          );
          textChangedIds.clear();
        }
      }
    }
    if (textChangedIds.size() > 0) {
      newAsyncRequests.add(
        new AsyncRequest__c(
          AsyncType__c = 'HandleUserPermission',
          Params__c = string.Join(textChangedIds, ',')
        )
      );
    }
    insert newAsyncRequests;
  }

  //Methods
  public void createProjectsFromOpps(
    fflib_ISObjectUnitOfWork uow,
    List<Opportunity> opps
  ) {
    //Consider here the design pattern that selects the correct project to update
    for (Opportunity opp : opps) {
      //Here update the creation of the project to use the factory pattern ProjectCreateFactory, and based on the values from the opp select the appropiate opportunity, consider using reflection for this as well, with a metadata to select the project definitions, to do this first consider the business processes of projects
      agf__PPM_Project__c project = ProjectCreateFactory.createProject(opp);
      //rest of the fields

      //uow register new
      system.debug(
        'Creating project from this opporunity: ' +
        opp.name +
        '. --> Project: ' +
        project
      );
      uow.registerNew(project);
    }
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Projects(sObjectList);
    }
  }
}
