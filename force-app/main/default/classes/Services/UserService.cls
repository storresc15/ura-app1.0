/*********************************************************************************
Class Name      : ProjectService
Description     : Main Project Service Class to be used on the application
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*********************************************************************************/
public with sharing class UserService {
    
    public static void createUserFromContact(Set<Id> oppIds) {
        
    }
    
    private static IUserService service() {
		return (IUserService) Application.Service.newInstance(IUserService.class);
	}

}