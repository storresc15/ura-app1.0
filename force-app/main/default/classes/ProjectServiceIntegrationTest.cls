@IsTest(seeAllData=true)
public class ProjectServiceIntegrationTest {
  @IsTest
  static void testProjectCheckout() {
    Set<Id> oppIds = new Set<Id>();
    for (Opportunity opp : [
      SELECT
        ID,
        Amount,
        StageName,
        CloseDate,
        Project_Type__c,
        Planned_Start_Date__c
      FROM Opportunity
      WHERE
        Amount != NULL
        AND StageName = 'Closed Won'
        AND CloseDate != NULL
        AND Project_Type__c = 'Salesforce_Implementation'
        AND Planned_Start_Date__c != NULL
      LIMIT 10
    ]) {
      oppIds.add(opp.id);
    }
    ProjectsService.projectCheckout(oppIds);
  }

  @isTest
  static void testGrantingAccessToUsers() {
    Set<Id> projectids = new Set<Id>();
    for (agf__PPM_Project__c project : [
      SELECT id
      FROM agf__PPM_Project__c
      LIMIT 10
    ]) {
      projectids.add(project.id);
    }
    agf__PPM_Project__c inactiveProject = [
      SELECT id, Active__c
      FROM agf__PPM_Project__c
      WHERE Active__c = TRUE
      LIMIT 1
    ];
    inactiveProject.Active__c = false;
    projectids.add(inactiveProject.id);
    update inactiveProject;

    Id userId = UserInfo.getUserId();

    System.runAs(new User(Id = userId)) {
      ProjectsService.handleProjectsAccessToUsers(projectids);
    }
  }
}
