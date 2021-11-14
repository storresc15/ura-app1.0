/*******************************************************************************
Class Name      : ProjectServiceImpl
Description     : Main Class for project service implementation
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
Sebastian                 2021-11-13              Updated method to accept project instead of set of contact id
*******************************************************************************/
public inherited sharing class ProjectsServiceImpl implements IProjectsService {
  public void projectCheckout(Set<Id> oppIds) {
    //To be implemented

    //To be added logic to create a project based on the closing of an opporuntiy

    //uow
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    //Select the opporunities closed from trigger

    //Use the domain class of projects to create them
    //Call uow to have the dml ready to create
    new Projects(new List<agf__PPM_Project__c>())
      .createProjectsFromOpps(
        uow,
        new OpportunitiesSelector().selectById(oppIds)
      );

    //iterate through the different opps in order to gather information from them to populate the projects

    //create the projects using the project domain class and on the same method reference the uow in order to be placing them on the uow to perform a general dml from it

    //Commit work of uow in order to insert the projects
    //consider some sort of validation (This should probably come from the project domain class)

    //Consider some other use of strategy design pattern if there is a need to create different project properties based on the values comming from the opportunity closed

    uow.commitWork();
  }

  public void handleProjectsAccessToUsers(Set<Id> projectids) {
    //Set Unit of work
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    //Map of Accounts-Contact/Users
    Map<Id, Map<Id, User>> accConUserMap = new Map<Id, Map<Id, User>>();

    Set<Id> conIds = new Set<Id>();
    List<Contact> conList = new List<Contact>();

    for (
      agf__PPM_Project__c project : new ProjectsSelector()
        .selectById(projectids)
    ) {
      if (!accConUserMap.containsKey(project.Account__c)) {
        accConUserMap.put(project.Account__c, new Map<Id, User>());
      }
    }
    //Iterate over contacts by accountId
    for (
      Account a : new AccountsSelector()
        .selectAccountWithContacts(accConUserMap.keySet())
    ) {
      for (Contact c : a.contacts) {
        conIds.add(c.id);
        conList.add(c);
        accConUserMap.get(c.AccountId).put(c.id, new User());
      }
    }

    //Retrive all the users from Account's related contacts (Consider also person account here)
    UsersSelector userSelector = new UsersSelector();
    Map<Id, User> userMap = userSelector.selectyByContactIdWithPermissionSetsMap(
      conIds
    );

    for (Contact c : conList) {
      accConUserMap.get(c.AccountId).put(c.id, userMap.get(c.id));
    }
    //Delegate to Users Domain Class
    //Users users = (Users) Application.Domain.newInstance(new List<User>());
    Users users = new Users(userMap.values());

    //Find the permission set Id to set to users
    Id psId = '0PS5e0000050KRSGA2';

    //The main iteration to update permission sets
    for (
      agf__PPM_Project__c project : new ProjectsSelector()
        .selectById(projectids)
    ) {
      for (Id contactId : accConUserMap.get(project.Account__c).keySet()) {
        //Iterate over the users and grant or remove the permission set
        if (accConUserMap.get(project.Account__c).get(contactId) != null) {
          User u = accConUserMap.get(project.Account__c).get(contactId);
          if (project.Active__c) {
            users.assignPermissionSetOnUser(u, psId, uow);
          } else if (!project.Active__c) {
            users.removePermissionSetOnUser(u, psId, uow);
          }
        }
      }
    }
    uow.commitWork();
  }
}
