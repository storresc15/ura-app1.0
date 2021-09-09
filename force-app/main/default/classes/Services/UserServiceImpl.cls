/********************************************************************************
Class Name      : UserServiceImpl
Description     : Main Class for user service implementation
Created By      : Sebastian Torres
Created Date    : 2021-09-10
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-10              Initial version
********************************************************************************/
public inherited sharing class UserServiceImpl implements IUserService {
    
    public void createUserFromContact(Set<Id> conIds) {
        //To be implemented
        //Add uow

        //Select the contact by id contact selector

        //Iterate over the contacts and instantiate and add the respective users to the uow

        //COnsider a domain layer for users, is it even valid in these design patterns // If so , even consider a strategy pattern to create a type of user or selecting certain attributes about it from the contact information

        //commit the change of the uow
    }

}
