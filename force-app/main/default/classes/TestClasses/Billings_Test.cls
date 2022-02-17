@IsTest
public class Billings_Test {
  @IsTest
  static void createBillFromCases() {
    //Given
    Account acc = new Account(
      Name = 'A',
      Id = fflib_IDGenerator.generate(Schema.Account.SObjectType)
    );
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(
      mocks
    );

    Billings domain = new Billings(new List<Bill__c>());

    //When
    System.Test.startTest();
    List<Bill__c> bills = new List<Bill__c>{
      domain.createBillFromCases(acc, unitOfWorkMock, (double) 25.5)
    };
    System.Test.stopTest();

    //Then
    system.assert(bills.size() > 0);
  }
}
