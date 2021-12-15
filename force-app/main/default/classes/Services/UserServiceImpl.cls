/*******************************************************************************
Class Name      : UserServiceImpl
Description     : Main Class for user service implementation
Created By      : Sebastian Torres
Created Date    : 2021-09-10
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-10              Initial version
Sebastian                 2021-10-01              Updated with the inactivate method and added the Domain class
******************************************************************************/
public inherited sharing class UserServiceImpl implements IUserService {
  public void activateUserFromContact(Set<Id> conIds) {
    //To be implemented
    //Add uow
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    //Have this profile selected by conditions, not hardcoded
    Profile p = [SELECT id FROM Profile WHERE name = 'URA Customer User'];

    //Select the contact by id contact selector
    ContactsSelector contactSelector = new ContactsSelector();
    List<Contact> cons = contactSelector.selectById(conIds);

    UsersSelector userSelector = new UsersSelector();

    Map<Id, User> contactUserMap = new Map<Id, User>();
    for (User u : userSelector.selectByContactId(conIds)) {
      contactUserMap.put(u.ContactId, u);
    }

    //Delegate to Users Domain Class

    //Users users = (Users) Application.Domain.newInstance(new List<User>());
    Users users = new Users(contactUserMap.values());

    //Iterate over the contacts and instantiate and add the respective users to the uow

    for (Contact c : cons) {
      //Consider a strategy pattern to create a type of user or selecting certain attributes about it from the contact information
      //If map does not contains Key create the user
      if (!contactUserMap.containsKey(c.Id)) {
        users.buildExperienceUserFromContact(c, p, uow);
      } else if (contactUserMap.containsKey(c.id)) {
        users.activateUser(contactUserMap.get(c.id), uow);
      }
    }

    //commit the change of the uow
    uow.commitWork();
  }

  public void deactivateUserFromContact(Set<Id> conIds) {
    //Add uow
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    //Select the contact by id contact selector
    ContactsSelector contactSelector = new ContactsSelector();
    List<Contact> cons = contactSelector.selectById(conIds);

    UsersSelector userSelector = new UsersSelector();

    Map<Id, User> contactUserMap = new Map<Id, User>();

    for (User u : userSelector.selectByContactId(conIds)) {
      contactUserMap.put(u.ContactId, u);
    }

    //Iterate over the contacts and instantiate and add the respective users to the uow

    //Delegate to Users Domain Class
    //Users users = (Users) Application.Domain.newInstance(contactUserMap.values());
    Users users = new Users(contactUserMap.values());

    for (Contact c : cons) {
      //Consider a strategy pattern to create a type of user or selecting certain attributes about it from the contact information
      //If map does not contains Key create the user
      if (contactUserMap.containsKey(c.id)) {
        users.deactivateUser(contactUserMap.get(c.id), uow);
      }
    }

    //commit the change of the uow
    uow.commitWork();
  }
}
