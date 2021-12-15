/******************************************************************************
Class Name      : IUserService
Description     : Main UserService Interface
Created By      : Sebastian Torres
Created Date    : 2021-09-10
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-10              Initial version
*******************************************************************************/
public interface IUserService {
  void activateUserFromContact(Set<Id> conIds);

  void deactivateUserFromContact(Set<Id> conIds);
}
