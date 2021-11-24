@IsTest(SeeAllData=true)
public class URAProjectsController_Test {
  /*
    @TestSetup
    static void testSetupMethod(){
        TestDataFactory_URA1 builder = new TestDataFactory_URA1();
        builder.buildData();
        
        Contact c = [Select Id, AccountID From Contact LIMIT 1];
        system.debug('The contact: ' + c);
        //Create the user
         String uniqueUserName = 'communityuser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='URA Customer User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        ContactId = c.id, 
        UserName=uniqueUserName);
        insert u;
        
    }
    */
  @IsTest
  static void projectControllerIntegrationTest() {
    User u = [
      SELECT ID, Username, ContactId, AccountId, Email, IsActive
      FROM USER
      WHERE Username = 'jrogers@burlington.com.invalid'
    ];
    system.debug('The user: ' + u);

    System.runAs(u) {
      // Assuming u has
      system.debug(UserInfo.getUserName());
      system.debug(UserInfo.getProfileId());
      List<URAProjectsController.ProjectWrapper> projects;
      projects = URAProjectsController.getProjects();
      system.debug('The projects: ' + projects);
      //stem.assert(projects.size() == 0);
    }
  }

  @IsTest
  static void whengetProjectsIsCalled() {
    /*Id mockUserId = fflib_IDGenerator.generate(User.SObjectType);
        Id mockAccountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id mockProjectId = fflib_IDGenerator.generate(agf__PPM_Project__c.SObjectType);
        Id mockSprintId = fflib_IDGenerator.generate(agf__ADM_Sprint__c.SObjectType);
        Id mockStoryId = fflib_IDGenerator.generate(agf__ADM_Work__c.SObjectType);
        List<User> userList = new List<User>{new User(Id = mockUserId)};
        List<agf__PPM_Project__c> projectList = new List<agf__PPM_Project__c>{new agf__PPM_Project__c(Id = mockProjectId)};
        List<agf__ADM_Work__c> storyList = new List<agf__ADM_Work__c>{new agf__ADM_Work__c(Id = mockStoryId)};
        fflib_ApexMocks mocks = new fflib_ApexMocks();
            
        //Given    
        UsersSelector mockUserSelector = (UsersSelector) mocks.mock(UsersSelector.class);
        ProjectsSelector mockProjectSelector = (ProjectsSelector) mocks.mock(ProjectsSelector.class);
        StoriesSelector mockStoriesSelector = (StoriesSelector) mocks.mock(StoriesSelector.class);
        
        mocks.startStubbing();
        //Mocking the projects
        mocks.when(mockProjectSelector.SObjectType()).
            thenReturn(agf__PPM_Project__c.SObjectType);
        mocks.when(mockProjectSelector.selectByAccIdWithSprintsAndEpics(new set<id> {mockAccountId})).
            thenReturn(projectList);
        //Mocking the stories
        mocks.when(mockStoriesSelector.SObjectType()).
            thenReturn(agf__ADM_Work__c.SObjectType);
        mocks.when(mockStoriesSelector.selectBySprintId(new set<id> {mockSprintId})).
            thenReturn(storyList);
        mocks.stopStubbing();
        
        //Given Inject Mocks
        Application.Selector.setMock(mockProjectSelector);
        Application.Selector.setMock(mockStoriesSelector);
        
        //When
        try{
            URAProjectsController.getProjects();
        } catch(Exception e) {
            system.debug('Excepction: ' + e.getCause());
        }*/
  }
}
