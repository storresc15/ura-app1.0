@isTest
public with sharing class BillingSupportTickets_BatchService_Test {
  @TestSetup
  static void testSetupMethod() {
    TestDataFactory_URA1 builder = new TestDataFactory_URA1();
    builder.buildData();
  }

  @isTest
  static void testBatch() {
    test.startTest();

    BillingSupportTickets_BatchService obj = new BillingSupportTickets_BatchService();
    Database.executeBatch(obj);

    SchedulableContext sc = null;
    BillingSupportTickets_BatchService tsc = new BillingSupportTickets_BatchService();
    tsc.execute(sc);

    test.stopTest();
  }
}
