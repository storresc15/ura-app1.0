@IsTest(seeAllData=true)
public class UserCreationIntegrarionTest {
  @IsTest
  static void testUserCreation() {
    List<Contact> consToupdate = new List<Contact>();
    for (Contact c : [
      SELECT ID, Active__c
      FROM Contact
      WHERE AccountID != NULL AND Active__c != TRUE
      LIMIT 10
    ]) {
      c.Active__c = true;
      consToupdate.add(c);
    }
    update consToupdate;
  }
}
