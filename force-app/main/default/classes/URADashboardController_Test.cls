@IsTest
public class URADashboardController_Test {
  @TestSetup
  static void testSetupMethod() {
    TestDataFactory_URA1 builder = new TestDataFactory_URA1();
    builder.buildData();
  }

  @IsTest
  static void dashboardIntegrationTest() {
    URADashboardController.DashboardInfoWrapper wrapper = URADashboardController.getDashboardInfo();
    system.assert(wrapper.projectsInfo.size() == 0);
  }

  @IsTest
  static void whengetMyActiveProjectsIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    ProjectsSelector mockSelector = (ProjectsSelector) mocks.mock(
      ProjectsSelector.class
    );

    //Application.Selector.setMock(ProjectsSelector.class, mockSelector);
    Id accId = fflib_IDGenerator.generate(Account.SObjectType);
    URADashboardController.getMyActiveProjects(accId);

    List<Exception> exceptions = new List<Exception>();

    try {
      URADashboardController.getMyActiveProjects('');
    } catch (Exception e) {
      exceptions.add(e);
    }
    system.assert(exceptions.size() > 0);

    Account a = [SELECT ID FROM ACCOUNT LIMIT 1];
    URADashboardController.getMyActiveProjects(a.id);
  }

  @IsTest
  static void whenGetTotalBalanceIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    //Given
    BillingServiceImpl mockService = (BillingServiceImpl) mocks.mock(
      BillingServiceImpl.class
    );
    Application.Service.setMock(BillingService.class, mockService);
    //When
    Id accId = fflib_IDGenerator.generate(Account.SObjectType);
    URADashboardController.getTotalBalance(accId);

    List<Exception> exceptions = new List<Exception>();

    try {
      URADashboardController.getTotalBalance('');
    } catch (Exception e) {
      exceptions.add(e);
    }
    system.assert(exceptions.size() > 0);
  }
  @IsTest
  static void whengetCasesCountIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    CasesSelector mockSelector = (CasesSelector) mocks.mock(
      CasesSelector.class
    );

    //Application.Selector.setMock(ProjectsSelector.class, mockSelector);
    Id accId = fflib_IDGenerator.generate(Account.SObjectType);
    String result = URADashboardController.getCasesCount(accId);

    List<Exception> exceptions = new List<Exception>();

    try {
      URADashboardController.getCasesCount('');
    } catch (Exception e) {
      exceptions.add(e);
    }
    system.assert(exceptions.size() > 0);
  }
}
