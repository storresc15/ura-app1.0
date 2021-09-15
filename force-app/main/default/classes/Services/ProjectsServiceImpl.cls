/*******************************************************************************
Class Name      : ProjectServiceImpl
Description     : Main Class for project service implementation
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
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
}
