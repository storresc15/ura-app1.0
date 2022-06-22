@isTest
public class SupportService_Test {
  @isTest
  static void whenSetSupportEntitlementIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitofWork) mocks.mock(
      fflib_SObjectUnitofWork.class
    );
    CasesSelector mockSelector = (CasesSelector) mocks.mock(
      CasesSelector.class
    );
    EntitlementsSelector mockSelectorEnt = (EntitlementsSelector) mocks.mock(
      EntitlementsSelector.class
    );
    Cases mockDomain = (Cases) mocks.mock(Cases.class);

    //Given - Configure mock response
    Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
    Id testCaseId1 = fflib_IDGenerator.generate(Case.SObjectType);
    Id testCaseId2 = fflib_IDGenerator.generate(Case.SObjectType);
    Id TestEntitlementId = fflib_IDGenerator.generate(Entitlement.SObjectType);

    List<Account> accList = new List<Account>{
      new Account(id = testAccountId, Name = 'Test Account')
    };
    Case c = new Case(
      id = testCaseId1,
      subject = 'Testing',
      Description = 'Testing',
      Type = 'Testing'
    );

    List<Account> testAccountsWithCases = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      accList,
      Case.AccountId,
      new List<List<Case>>{
        new List<Case>{
          new Case(
            id = testCaseId2,
            subject = 'Testing',
            Description = 'Testing',
            Type = 'Testing'
          ),
          c
        }
      }
    );
    List<Account> testAccountsWithEntitlements = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      accList,
      Entitlement.AccountId,
      new List<List<Entitlement>>{
        new List<Entitlement>{
          new Entitlement(
            AccountId = testAccountId,
            id = TestEntitlementId,
            Name = 'Testing',
            StartDate = Date.valueof(System.now().addDays(-2)),
            EndDate = Date.valueof(System.now().addYears(2))
          )
        }
      }
    );

    system.debug(
      'The entitlements: ' + testAccountsWithEntitlements[0].Entitlements
    );
    system.debug(
      'The entitlement AccountId: ' +
      testAccountsWithEntitlements[0].Entitlements[0].AccountId
    );
    system.debug('The Cases: ' + testAccountsWithCases[0].Cases);
    mocks.startStubbing();
    mocks.when(mockSelector.SObjectType()).thenReturn(Case.SObjectType);
    mocks.when(mockSelector.selectById(new Set<Id>{ testCaseId1, testCaseId2 }))
      .thenReturn(testAccountsWithCases[0].cases);

    mocks.when(mockSelectorEnt.SObjectType())
      .thenReturn(Entitlement.SObjectType);
    mocks.when(
        mockSelectorEnt.selectFromAccountIds(new Set<Id>{ testAccountId })
      )
      .thenReturn(testAccountsWithEntitlements[0].Entitlements);

    mocks.when(mockDomain.SObjectType()).thenReturn(Case.SObjectType);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockSelector);
    Application.Selector.setMock(mockSelectorEnt); // Check this second setMock
    Application.Domain.setMock((fflib_ISObjectDomain) mockDomain);
    //When
    SupportService.setSupportEntitlement(
      new Set<Id>{ testCaseId1, testCaseId2 }
    );
    //Then
    ((CasesSelector) mocks.verify(mockSelector, 1))
      .selectById(new Set<Id>{ testCaseId1, testCaseId2 });
    // ((EntitlementsSelector) mocks.verify(mockSelectorEnt, 1)).
    //   selectFromAccountIds(new Set<Id>{testAccountId});
  }

  @isTest
  static void whenSetCaseAssignmentRuleIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitofWork) mocks.mock(
      fflib_SObjectUnitofWork.class
    );
    CasesSelector mockSelector = (CasesSelector) mocks.mock(
      CasesSelector.class
    );

    //Given - Configure mock response
    Id testCaseId = fflib_IDGenerator.generate(Case.SObjectType);

    List<Case> caseList = new List<Case>{
      new Case(id = testCaseId, subject = 'Testing', Description = 'Testing')
    };

    mocks.startStubbing();
    mocks.when(mockSelector.SObjectType()).thenReturn(Case.SObjectType);
    mocks.when(mockSelector.selectById(new Set<Id>{ testCaseId }))
      .thenReturn(caseList);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockSelector);

    //When
    SupportService.setCaseAssignmentRule(new Set<Id>{ testCaseId });

    //Then
    ((CasesSelector) mocks.verify(mockSelector, 1))
      .selectById(new Set<Id>{ testCaseId });
    ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, 1)).commitWOrk();
  }

  @IsTest
  static void whenSetEntitlementsAssigmentsIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitofWork) mocks.mock(
      fflib_SObjectUnitofWork.class
    );
    CasesSelector mockSelector = (CasesSelector) mocks.mock(
      CasesSelector.class
    );

    //Given - Configure mock response
    Id testCaseId = fflib_IDGenerator.generate(Case.SObjectType);

    List<Case> caseList = new List<Case>{
      new Case(id = testCaseId, subject = 'Testing', Description = 'Testing')
    };

    mocks.startStubbing();
    mocks.when(mockSelector.SObjectType()).thenReturn(Case.SObjectType);
    mocks.when(mockSelector.selectById(new Set<Id>{ testCaseId }))
      .thenReturn(caseList);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockSelector);

    //When
    SupportService.setEntitlementsAssigments(new Set<Id>{ testCaseId });

    //Then
    ((CasesSelector) mocks.verify(mockSelector, 2))
      .selectById(new Set<Id>{ testCaseId });
    ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, 1)).commitWOrk();
  }

  @IsTest
  static void whenSetEntitlementSupportOnAccountIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitofWork) mocks.mock(
      fflib_SObjectUnitofWork.class
    );
    AccountsSelector mockSelectorAcc = (AccountsSelector) mocks.mock(
      AccountsSelector.class
    );
    EntitlementsSelector mockSelectorEnt = (EntitlementsSelector) mocks.mock(
      EntitlementsSelector.class
    );
    Cases mockDomain = (Cases) mocks.mock(Cases.class);

    //Given - Configure mock response
    Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
    Id testCaseId = fflib_IDGenerator.generate(Case.SObjectType);
    Id TestEntitlementId = fflib_IDGenerator.generate(Entitlement.SObjectType);

    List<Account> accList = new List<Account>{
      new Account(id = testAccountId, Name = 'Test Account', SLA__C = 'Gold')
    };

    List<Account> testAccountsWithCases = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      accList,
      Case.AccountId,
      new List<List<Case>>{
        new List<Case>{
          new Case(
            id = testCaseId,
            subject = 'Testing',
            Description = 'Testing',
            Type = 'Testing'
          )
        }
      }
    );
    List<Account> testAccountsWithEntitlements = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      testAccountsWithCases,
      Entitlement.AccountId,
      new List<List<Entitlement>>{
        new List<Entitlement>{
          new Entitlement(
            AccountId = testAccountId,
            id = TestEntitlementId,
            Name = 'Testing',
            StartDate = Date.valueof(System.now().addDays(-2)),
            EndDate = Date.valueof(System.now().addYears(2))
          )
        }
      }
    );

    system.debug(
      '---SUPPORT ON ACCOUNT - The Account: ' + testAccountsWithEntitlements[0]
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The entitlements: ' +
      testAccountsWithEntitlements[0].Entitlements
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The entitlement AccountId: ' +
      testAccountsWithEntitlements[0].Entitlements[0].AccountId
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The Cases: ' +
      testAccountsWithEntitlements[0].Cases
    );
    mocks.startStubbing();
    mocks.when(mockSelectorAcc.SObjectType()).thenReturn(Account.SObjectType);
    mocks.when(
        mockSelectorAcc.selectAccountWithCasesAndEntitlements(
          new Set<Id>{ testAccountId }
        )
      )
      .thenReturn(testAccountsWithEntitlements);

    mocks.when(mockSelectorEnt.SObjectType())
      .thenReturn(Entitlement.SObjectType);
    mocks.when(
        mockSelectorEnt.selectFromAccountIds(new Set<Id>{ testAccountId })
      )
      .thenReturn(testAccountsWithEntitlements[0].Entitlements);

    mocks.when(mockDomain.SObjectType()).thenReturn(Case.SObjectType);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockSelectorAcc);
    Application.Selector.setMock(mockSelectorEnt); // Check this second setMock
    Application.Domain.setMock((fflib_ISObjectDomain) mockDomain);
    //When
    SupportService.setEntitlementSupportOnAccount(new Set<Id>{ testAccountId });
    //Then
    ((AccountsSelector) mocks.verify(mockSelectorAcc, 1))
      .selectAccountWithCasesAndEntitlements(new Set<Id>{ testAccountId });

    ((EntitlementsSelector) mocks.verify(mockSelectorEnt, 1))
      .selectFromAccountIds(new Set<Id>{ testAccountId });

    ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, 1)).commitWOrk();
  }

  @IsTest
  static void shouldThrowExceptionInSetEntitlementSupportOnAccount() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitofWork) mocks.mock(
      fflib_SObjectUnitofWork.class
    );
    AccountsSelector mockSelectorAcc = (AccountsSelector) mocks.mock(
      AccountsSelector.class
    );
    EntitlementsSelector mockSelectorEnt = (EntitlementsSelector) mocks.mock(
      EntitlementsSelector.class
    );
    Cases mockDomain = (Cases) mocks.mock(Cases.class);

    //Given - Configure mock response
    Id testAccountId = fflib_IDGenerator.generate(Account.SObjectType);
    Id testCaseId = fflib_IDGenerator.generate(Case.SObjectType);
    Id TestEntitlementId = fflib_IDGenerator.generate(Entitlement.SObjectType);

    List<Account> accList = new List<Account>{
      new Account(id = testAccountId, Name = 'Test Account', SLA__C = 'XXENT')
    };

    List<Account> testAccountsWithCases = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      accList,
      Case.AccountId,
      new List<List<Case>>{
        new List<Case>{
          new Case(
            id = testCaseId,
            subject = 'Testing',
            Description = 'Testing',
            Type = 'Testing'
          )
        }
      }
    );
    List<Account> testAccountsWithEntitlements = (List<Account>) fflib_ApexMocksUtils.makeRelationship(
      List<Account>.class,
      testAccountsWithCases,
      Entitlement.AccountId,
      new List<List<Entitlement>>{
        new List<Entitlement>{
          new Entitlement(
            AccountId = testAccountId,
            id = TestEntitlementId,
            Name = 'Testing',
            StartDate = Date.valueof(System.now().addDays(-2)),
            EndDate = Date.valueof(System.now().addYears(2))
          )
        }
      }
    );

    system.debug(
      '---SUPPORT ON ACCOUNT - The Account: ' + testAccountsWithEntitlements[0]
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The entitlements: ' +
      testAccountsWithEntitlements[0].Entitlements
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The entitlement AccountId: ' +
      testAccountsWithEntitlements[0].Entitlements[0].AccountId
    );
    system.debug(
      '---SUPPORT ON ACCOUNT - The Cases: ' +
      testAccountsWithEntitlements[0].Cases
    );
    mocks.startStubbing();
    mocks.when(mockSelectorAcc.SObjectType()).thenReturn(Account.SObjectType);
    mocks.when(
        mockSelectorAcc.selectAccountWithCasesAndEntitlements(
          new Set<Id>{ testAccountId }
        )
      )
      .thenReturn(testAccountsWithEntitlements);

    mocks.when(mockSelectorEnt.SObjectType())
      .thenReturn(Entitlement.SObjectType);
    mocks.when(
        mockSelectorEnt.selectFromAccountIds(new Set<Id>{ testAccountId })
      )
      .thenReturn(testAccountsWithEntitlements[0].Entitlements);

    mocks.when(mockDomain.SObjectType()).thenReturn(Case.SObjectType);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockSelectorAcc);
    Application.Selector.setMock(mockSelectorEnt); // Check this second setMock
    Application.Domain.setMock((fflib_ISObjectDomain) mockDomain);
    //When
    try {
      SupportService.setEntitlementSupportOnAccount(
        new Set<Id>{ testAccountId }
      );
    } catch (Exception e) {
      system.debug('The Exception e: ' + e);
    }
    //Then
    ((AccountsSelector) mocks.verify(mockSelectorAcc, 1))
      .selectAccountWithCasesAndEntitlements(new Set<Id>{ testAccountId });
  }
}
