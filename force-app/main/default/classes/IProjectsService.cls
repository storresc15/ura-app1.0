/*********************************************************************************
Class Name      : IProjectsService
Description     : Main ProjectService Interface
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*********************************************************************************/
public interface IProjectsService {
    
    void projectCheckout(Set<Id> oppIds);

}