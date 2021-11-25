@IsTest(SeeAllData=true)
public class CaseAssignmentsTest {
  @isTest
  static void caseCreationTest() {
    Case c = new Case(Subject = 'Test Case');
    insert c;
  }

  @isTest
  static void caseUpdatedEntitlement() {
    Case c = [
      SELECT ID, Subject, EntitlementId
      FROM Case
      WHERE EntitlementId != NULL AND id = '5005e000005kfWyAAI'
      LIMIT 1
    ];
    c.EntitlementId = null;
    update c;
  }
}
