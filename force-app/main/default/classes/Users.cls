/*******************************************************************************
Class Name      : Users
Description     : Main Domain class for User Object
Created By      : Sebastian Torres
Created Date    : 2021-10-01  
Modification Log:
-------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                2021-10-01             Initial version
*******************************************************************************/
public inherited sharing class Users extends ApplicationDomain {
  public Users(List<User> users) {
    super(users);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  //Method to build a user
  public void buildExperienceUserFromContact(
    Contact c,
    Profile p,
    fflib_ISObjectUnitOfWork uow
  ) {
    User u = new User(
      alias = c.FirstName.substring(0, 1) + c.LastName.substring(0, 2) + 'ur',
      email = c.Email,
      emailencodingkey = 'UTF-8',
      firstName = c.FirstName,
      lastname = c.LastName,
      languagelocalekey = 'en_US',
      localesidkey = 'en_US',
      profileid = p.id,
      contactId = c.Id,
      timezonesidkey = 'Europe/London',
      username = c.Email + '.ura',
      isActive = true
    );
    system.debug('Creating this user from the User Domain Class: ' + u);
    uow.registerNew(u);
  }

  public void activateUser(User u, fflib_ISObjectUnitOfWork uow) {
    u.IsActive = true;
    system.debug('Updating this user from Domain: ' + u);
    uow.registerDirty(u);
  }

  public void deactivateUser(User u, fflib_ISObjectUnitOfWork uow) {
    u.IsActive = false;
    system.debug('Updating this user: ' + u + 'To inactive from Domain');
    uow.registerDirty(u);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Users(sObjectList);
    }
  }
}
