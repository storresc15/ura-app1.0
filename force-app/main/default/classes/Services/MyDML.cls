/*******************************************************************************
Class Name      : MyDML
Description     : Class used to override the standard IDML on Unit of work to leverage the dml options for case assignment rule
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/

public class MyDML implements fflib_SObjectUnitOfWork.IDML {
  private Database.DMLOptions dmlOptions;

  public Database.DMLOptions getDMLOptions() {
    return dmlOptions;
  }

  public MyDML() {
    AssignmentRule AR = new AssignmentRule();
    AR = [
      SELECT id
      FROM AssignmentRule
      WHERE SobjectType = 'Case' AND Active = TRUE
      LIMIT 1
    ];
    dmlOptions = new Database.DMLOptions();
    dmlOptions.assignmentRuleHeader.assignmentRuleId = AR.id;
  }

  public void dmlInsert(List<SObject> objList) {
    Database.insert(objList, dmlOptions);
  }

  public void dmlUpdate(List<SObject> objList) {
    Database.update(objList, dmlOptions);
  }

  public void dmlDelete(List<SObject> objList) {
    delete objList;
  }
  public virtual void eventPublish(List<SObject> objList) {
    EventBus.publish(objList);
  }
  public virtual void emptyRecycleBin(List<SObject> objList) {
    if (objList.isEmpty()) {
      return;
    }

    Database.emptyRecycleBin(objList);
  }
}
