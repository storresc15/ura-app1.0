public class TestDataFactory_URA1 {
  public integer numOfRecords = 10; // to be updated with the metadata required for this

  public void buildData() {
    createUser();
    List<Account> accs = createAccounts();
    insert accs;
    List<Contact> cons = createContacts(accs[0]);
    insert cons;
    List<agf__PPM_Project__c> projects = createProjects(accs[0]);
    insert projects;
    List<agf__ADM_Epic__c> epics = createEpics(projects[0]);
    insert epics;
    List<agf__ADM_Sprint__c> sprints = createSprints(projects[0]);
    insert sprints;
    List<agf__ADM_Work__c> stories = createStories(sprints[0]);
    insert stories;
  }

  public void createUser() {
  }
  public List<Account> createAccounts() {
    List<Account> accounts = new List<Account>();
    for (integer i = 0; i < numOfRecords; i++) {
      accounts.add(new Account(Name = 'Test Acc' + i));
    }
    return accounts;
  }
  public List<Contact> createContacts(Account acc) {
    List<Contact> cons = new List<Contact>();
    for (integer i = 0; i < numOfRecords; i++) {
      cons.add(
        new Contact(
          FirstName = 'Test',
          LastName = 'Contact' + i,
          AccountID = acc.Id
        )
      );
    }
    return cons;
  }
  public List<agf__PPM_Project__c> createProjects(Account acc) {
    List<agf__PPM_Project__c> projects = new List<agf__PPM_Project__c>();
    for (integer i = 0; i < numOfRecords; i++) {
      projects.add(
        new agf__PPM_Project__c(
          Name = 'Test' + i,
          agf__Project_Summary__c = 'Desc ' + i,
          Account__c = acc.Id
        )
      );
    }
    return projects;
  }
  public List<agf__ADM_Epic__c> createEpics(agf__PPM_Project__c project) {
    List<agf__ADM_Epic__c> epics = new List<agf__ADM_Epic__c>();
    for (integer i = 0; i < numOfRecords; i++) {
      epics.add(
        new agf__ADM_Epic__c(
          name = 'Test Epic' + i,
          agf__Project__c = project.id
        )
      );
    }
    return epics;
  }
  public List<agf__ADM_Sprint__c> createSprints(agf__PPM_Project__c project) {
    agf__ADM_Scrum_Team__c team = new agf__ADM_Scrum_Team__c(
      Name = 'Test Team',
      agf__Cloud__c = 'Platform'
    );
    insert team;
    agf__ADM_Product_Tag__c tag = new agf__ADM_Product_Tag__c(
      Name = 'Test Product',
      agf__Team__c = team.id
    );
    insert tag;
    List<agf__ADM_Sprint__c> sprints = new List<agf__ADM_Sprint__c>();
    for (integer i = 0; i < numOfRecords; i++) {
      sprints.add(
        new agf__ADM_Sprint__c(
          Name = '2021.01a-MTest' + i,
          agf__Scrum_Team__c = team.id,
          agf__Start_Date__c = Date.today(),
          agf__End_Date__c = Date.today().addDays(30),
          Project__c = project.id
        )
      );
    }
    return sprints;
  }
  public List<agf__ADM_Work__c> createStories(agf__ADM_Sprint__c sprint) {
    agf__ADM_Product_Tag__c tag = [
      SELECT ID
      FROM agf__ADM_Product_Tag__c
      LIMIT 1
    ];
    List<agf__ADM_Work__c> stories = new List<agf__ADM_Work__c>();
    for (integer i = 0; i < numOfRecords; i++) {
      stories.add(
        new agf__ADM_Work__c(
          agf__Subject__c = 'Test Story' + i,
          agf__Product_Tag__c = tag.id,
          agf__Sprint__c = sprint.id
        )
      );
    }
    return stories;
  }
  public void createCases(Contact con) {
  }
}
