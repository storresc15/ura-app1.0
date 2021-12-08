@isTest
public class BillingSupportProjects_BatchService_Test {
  @TestSetup
  static void testSetupMethod() {
    TestDataFactory_URA1 builder = new TestDataFactory_URA1();
    builder.buildData();
  }

  @isTest
  static void testBatch() {
    test.startTest();

    BillingSupportProjects_BatchService obj = new BillingSupportProjects_BatchService();
    Database.executeBatch(obj);

    SchedulableContext sc = null;
    BillingSupportProjects_BatchService tsc = new BillingSupportProjects_BatchService();
    tsc.execute(sc);

    test.stopTest();
  }
}
