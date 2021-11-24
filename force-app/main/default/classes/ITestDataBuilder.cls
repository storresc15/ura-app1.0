public interface ITestDataBuilder {
  void createUser();
  void createAccounts();
  void createContacts(Account acc);
  void createProjects(Account acc);
  void createEpics(agf__PPM_Project__c project);
  void createSprints(agf__PPM_Project__c project);
  void createStories(agf__ADM_Sprint__c sprint);
  void createCases(Contact con);
}
