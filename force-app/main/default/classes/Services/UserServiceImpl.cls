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
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        
        //Have this profile selected by conditions, not hardcoded
        Profile p = [select id from Profile where name='Customer Community User'];

        //Select the contact by id contact selector
        ContactsSelector contactSelector = new ContactsSelector();
        List<Contact> cons = contactSelector.selectById(conIds);
        
        UsersSelector userSelector = new UsersSelector();
        
        Map<Id, User> contactUserMap = new Map<Id, User>();
        for(User u : userSelector.selectByContactId(conIds)) {
            contactUserMap.put(u.ContactId, u);
        }

        //Iterate over the contacts and instantiate and add the respective users to the uow
        
        for(Contact c : cons) {
            //Consider a strategy pattern to create a type of user or selecting certain attributes about it from the contact information
            //If map does not contains Key create the user
            if(!contactUserMap.containsKey(c.Id)) {
                User u = new User(alias = c.FirstName.substring(0,1) + c.LastName.substring(0,2) + 'ur', email=c.Email,
                 emailencodingkey='UTF-8', firstName= c.FirstName, lastname= c.LastName, languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.id, contactId = c.Id,
                 timezonesidkey='Europe/London', username= c.Email + '.ura', isActive = true);
                system.debug('Creating this user: ' + u);
                uow.registerNew(u);
            } else if(contactUserMap.containsKey(c.id)) {
                User u = contactUserMap.get(c.id);
                u.IsActive = true;
                system.debug('Updating this user: ' + u);
                uow.registerDirty(u);
            }
        }

        //commit the change of the uow
        uow.commitWork();
    }

}