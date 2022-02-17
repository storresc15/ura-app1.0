@IsTest
public class BillingService_Test {
  @IsTest
  static void generateBillFromProjectCheckout() {
    //Given a list of projects with cases
    List<Opportunity> opportunities = new List<Opportunity>{
      new Opportunity(
        Name = 'A',
        CloseDate = Date.today(),
        StageName = 'Closed Won',
        Amount = 2000,
        Id = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType)
      ),
      new Opportunity(
        Name = 'B',
        CloseDate = Date.today(),
        StageName = 'Prospecting',
        Amount = 2000,
        Id = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType)
      ),
      new Opportunity(
        Name = 'C',
        CloseDate = Date.today(),
        StageName = 'Prospecting',
        Amount = 2000,
        Id = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType)
      )
    };

    Set<Id> opportunityIds = new Map<Id, SObject>(opportunities).keySet();

    fflib_ApexMocks mocks = new fflib_ApexMocks();
    fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(
      mocks
    );
    OpportunitiesSelector selectorMock = (OpportunitiesSelector) mocks.mock(
      OpportunitiesSelector.class
    );
    Billings domainMock = (Billings) mocks.mock(Billings.class);

    mocks.startStubbing();
    mocks.when(selectorMock.sObjectType())
      .thenReturn(Schema.Opportunity.SObjectType);
    mocks.when(selectorMock.selectById(opportunityIds))
      .thenReturn(opportunities);
    mocks.when(domainMock.getType()).thenReturn(Schema.Bill__c.SObjectType);
    //mocks.when(domainMock.getRecords()).thenReturn(Bill__c);
    mocks.stopStubbing();

    Application.UnitOfWork.setMock(unitOfWorkMock);
    Application.Domain.setMock((fflib_ISObjectDomain) domainMock);
    Application.Selector.setMock(selectorMock);

    // WHEN we update the opportunity Activity
    System.Test.startTest();
    new BillingServiceImpl().generateBillFromProjectCheckout(opportunityIds);
    System.Test.stopTest();

    // THEN
    ((OpportunitiesSelector) mocks.verify(selectorMock))
      .selectById(opportunityIds);
    //((Billings) mocks.verify(domainMock)).createBillFromOpportunity(opportunities[0],unitOfWorkMock);
    //((fflib_ISObjectUnitOfWork)	mocks.verify(unitOfWorkMock)).registerDirty(accounts);
    ((fflib_ISObjectUnitOfWork) mocks.verify(unitOfWorkMock)).commitWork();
  }

  @IsTest
  static void testGenerateBillFromSupportProject() {
    //Given a list of projects with cases
    agf__PPM_Project__c projectMock1 = new agf__PPM_Project__c(
      Name = 'A',
      Id = fflib_IDGenerator.generate(Schema.agf__PPM_Project__c.SObjectType)
    );

    List<agf__PPM_Project__c> projectsWithCasesMock = (List<agf__PPM_Project__c>) fflib_ApexMocksUtils.makeRelationship(
      List<agf__PPM_Project__c>.class,
      new List<agf__PPM_Project__c>{ projectMock1 },
      Case.Project__c,
      new List<List<Case>>{
        new List<Case>{
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          ),
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          ),
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          )
        }
      }
    );

    Set<Id> projectIds = new Map<Id, SObject>(projectsWithCasesMock).keySet();
    Id project1Id = projectsWithCasesMock[0].id;

    fflib_ApexMocks mocks = new fflib_ApexMocks();
    fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(
      mocks
    );
    ProjectsSelector selectorMock = (ProjectsSelector) mocks.mock(
      ProjectsSelector.class
    );
    Cases casesDomainMock = (Cases) mocks.mock(Cases.class);

    mocks.startStubbing();
    mocks.when(selectorMock.sObjectType())
      .thenReturn(Schema.agf__PPM_Project__c.SObjectType);
    mocks.when(selectorMock.selectByIdWithCasesNotBilled(projectIds))
      .thenReturn(projectsWithCasesMock);
    mocks.when(casesDomainMock.getType()).thenReturn(Schema.Case.SObjectType);
    //mocks.when(casesDomainMock.getRecords()).thenReturn(projectsWithCasesMock.cases);
    mocks.stopStubbing();

    Application.UnitOfWork.setMock(unitOfWorkMock);
    Application.Domain.setMock((fflib_ISObjectDomain) casesDomainMock);
    Application.Selector.setMock(selectorMock);

    //When we generate the billings from the support cases
    System.Test.startTest();
    new BillingServiceImpl().generateBillFromSupportProject(projectIds);
    System.Test.stopTest();

    //Then the billing records should be created
    ((ProjectsSelector) mocks.verify(selectorMock))
      .selectByIdWithCasesNotBilled(projectIds);
    //((Cases) mocks.verify(domainMock)).updateOpportunityActivity();
    /*((fflib_ISObjectUnitOfWork)	mocks.verify(unitOfWorkMock)).registerNew(new List<Bill__c>{
            new Bill__c(),
            new Bill__c(),
            new Bill__c()    
        });*/
    ((fflib_ISObjectUnitOfWork) mocks.verify(unitOfWorkMock)).commitWork();

    /*
         ({"attributes":{"type":"Bill__c"},"Account__c":null,"Amount__c":0.0,"Description__c":"Bill Created Automatically for Account: null From Project Support: A"}), ({"attributes":{"type":"Bill__c"},"Account__c":null,"Amount__c":0.0,"Description__c":"Bill Created Automatically for Account: null From Project Support: B"}), ({"attributes":{"type":"Bill__c"},"Account__c":null,"Amount__c":0.0,"Description__c":"Bill Created Automatically for Account: null From Project Support: C"})
         * 
         */
  }

  @IsTest
  static void generateBillFromSupportTickets() {
    //Given a list of projects with cases
    //
    Account accountMock1 = new Account(
      Name = 'A',
      Id = fflib_IDGenerator.generate(Schema.Account.SObjectType)
    );

    List<Account> accountsWithCasesMock = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      new List<Account>{ accountMock1 },
      Case.AccountId,
      new List<List<Case>>{
        new List<Case>{
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          ),
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          ),
          new Case(
            Id = fflib_IDGenerator.generate(Schema.Case.SObjectType),
            Status = 'New',
            Origin = 'Phone',
            Support_Product__c = 'Salesforce',
            Support_Feature__c = 'ServiceCloud'
          )
        }
      }
    );

    Set<Id> accountIds = new Map<Id, SObject>(accountsWithCasesMock).keySet();
    Id accountId = accountsWithCasesMock[0].id;

    fflib_ApexMocks mocks = new fflib_ApexMocks();
    fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(
      mocks
    );
    AccountsSelector selectorMock = (AccountsSelector) mocks.mock(
      AccountsSelector.class
    );
    Cases casesDomainMock = (Cases) mocks.mock(Cases.class);
    Billings billingsDomainMock = (Billings) mocks.mock(Billings.class);

    mocks.startStubbing();
    mocks.when(selectorMock.sObjectType())
      .thenReturn(Schema.Account.SObjectType);
    mocks.when(selectorMock.selectAccountWithCasesForBilling(accountIds))
      .thenReturn(accountsWithCasesMock);
    mocks.when(casesDomainMock.getType()).thenReturn(Schema.Case.SObjectType);
    //mocks.when(casesDomainMock.getRecords()).thenReturn(accountsWithCasesMock.cases);
    mocks.stopStubbing();

    Application.UnitOfWork.setMock(unitOfWorkMock);
    Application.Domain.setMock((fflib_ISObjectDomain) casesDomainMock);
    Application.Domain.setMock((fflib_ISObjectDomain) billingsDomainMock);
    Application.Selector.setMock(selectorMock);

    //When we generate the billings from the support cases
    System.Test.startTest();
    new BillingServiceImpl().generateBillFromSupportTickets(accountIds);
    System.Test.stopTest();

    //Then the billing records should be created
    ((AccountsSelector) mocks.verify(selectorMock))
      .selectAccountWithCasesForBilling(accountIds);
    //((Cases) mocks.verify(domainMock)).updateOpportunityActivity();
    /*((fflib_ISObjectUnitOfWork)	mocks.verify(unitOfWorkMock)).registerNew(new List<Bill__c>{
            new Bill__c(),
            new Bill__c(),
            new Bill__c()    
        });*/
    ((fflib_ISObjectUnitOfWork) mocks.verify(unitOfWorkMock)).commitWork();
  }
}
