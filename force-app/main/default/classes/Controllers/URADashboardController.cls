/*******************************************************************************
Class Name      : URADashboardController
Description     : Controller class to expose on URA App the simple homepage dashboard to be used on a custom LWC
Created By      : Sebastian Torres
Created Date    : 2021-10-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-10-28              Initial version
*******************************************************************************/
public with sharing class URADashboardController {
  @AuraEnabled
  public static string getCasesCount(String accId) {
    try {
      CasesSelector selector = (CasesSelector) Application.Selector.newInstance(
        Case.sObjectType
      );
      Integer count = selector.getCasesCountByAccountId(new Set<Id>{ accId });
      return String.valueOf(count);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static string getTotalBalance(String accId) {
    try {
      Double amount = BillingService.getBalanceForUraApp(new Set<Id>{ accId });
      return String.valueOf(amount);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<ActiveProjectWrapper> getMyActiveProjects(String accId) {
    try {
      List<ActiveProjectWrapper> activeProjects = new List<ActiveProjectWrapper>();
      ProjectsSelector selector = (ProjectsSelector) Application.Selector.newInstance(
        agf__PPM_Project__c.sObjectType
      );

      for (
        agf__PPM_Project__c project : selector.selectByAccountId(
          new Set<Id>{ accId }
        )
      ) {
        ActiveProjectWrapper wrapper = new ActiveProjectWrapper();
        wrapper.ProjectAccount = project.Account__r.name;
        wrapper.ProjectName = project.name;
        wrapper.ScrumTeam = project.agf__Delivery_Scrum_Team__r.name;
        activeProjects.add(wrapper);
      }
      return activeProjects;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static DashboardInfoWrapper getDashboardInfo() {
    try {
      UsersSelector selector = new UsersSelector();
      List<User> lstUser = selector.selectByIdWithAccountId(
        new Set<Id>{ UserInfo.getUserId() }
      );
      String accId = lstUser[0].contact.AccountId;
      DashboardInfoWrapper dashboardInfo = new DashboardInfoWrapper();
      dashboardInfo.CaseCount = getCasesCount(accId);
      dashboardInfo.TotalBalance = getTotalBalance(accId);
      dashboardInfo.projectsInfo = getMyActiveProjects(accId);

      return dashboardInfo;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  public class ActiveProjectWrapper {
    @AuraEnabled
    public String ProjectName;
    @AuraEnabled
    public String ScrumTeam;
    @AuraEnabled
    public String ProjectAccount;
  }

  public class DashboardInfoWrapper {
    @AuraEnabled
    public List<ActiveProjectWrapper> projectsInfo;
    @AuraEnabled
    public String CaseCount;
    @AuraEnabled
    public String TotalBalance;
  }
}
