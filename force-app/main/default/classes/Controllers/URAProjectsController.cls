/*******************************************************************************
Class Name      : URAProjectsController
Description     : Controller class to expose on URA App the project content to users to be used on a custom LWC
Created By      : Sebastian Torres
Created Date    : 2021-11-03
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-11-03              Initial version
*******************************************************************************/
public without sharing class URAProjectsController {
  @AuraEnabled(cacheable=true)
  public static List<ProjectWrapper> getProjects() {
    List<ProjectWrapper> projectData = new List<ProjectWrapper>();

    try {
      UsersSelector selector = new UsersSelector();
      List<User> lstUser = selector.selectByIdWithAccountId(
        new Set<Id>{ UserInfo.getUserId() }
      );
      String accId = lstUser[0].contact.AccountId;
      ProjectsSelector projectSelector = (ProjectsSelector) Application.Selector.newInstance(
        agf__PPM_Project__c.SObjectType
      );
      StoriesSelector storySelector = (StoriesSelector) Application.Selector.newInstance(
        agf__ADM_Work__c.SObjectType
      );
      List<agf__PPM_Project__c> projectsList = projectSelector.selectByAccIdWithSprintsAndEpics(
        new Set<Id>{ accId }
      );

      Set<Id> sprintSet = new Set<Id>();
      Map<id, List<agf__ADM_Work__c>> storyMap = new Map<Id, List<agf__ADM_Work__c>>();
      Map<Id, List<String>> epicMap = new Map<Id, List<String>>();

      for (agf__PPM_Project__c project : projectsList) {
        epicMap.put(project.Id, new List<String>());
        for (agf__ADM_Sprint__c sprint : project.Sprints__r) {
          sprintSet.add(sprint.id);
        }
        for (agf__ADM_Epic__c epic : project.agf__Epics__r) {
          epicMap.get(project.id).add(epic.Name);
        }
      }
      for (agf__ADM_Work__c story : storySelector.selectBySprintId(sprintSet)) {
        if (!storyMap.containsKey(story.agf__Sprint__c)) {
          storyMap.put(
            story.agf__Sprint__c,
            new List<agf__ADM_Work__c>{ story }
          );
        } else {
          storyMap.get(story.agf__Sprint__c).add(story);
        }
      }

      for (agf__PPM_Project__c project : projectsList) {
        ProjectWrapper projectWrapper = new ProjectWrapper();
        projectWrapper.Sprints = wrappSprints(project.Sprints__r, storyMap);
        projectWrapper.ProjectDescription = project.agf__Project_Summary__c;
        projectWrapper.ProjectEpics = epicMap.get(project.Id);
        projectWrapper.ProjectName = project.Name;
        projectWrapper.ProjectNumber = project.Id;

        projectData.add(projectWrapper);
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    return projectData;
  }

  private static List<SprintWrapper> wrappSprints(
    List<agf__ADM_Sprint__c> sprintList,
    Map<id, List<agf__ADM_Work__c>> storyMap
  ) {
    List<SprintWrapper> sprints = new List<SprintWrapper>();

    for (agf__ADM_Sprint__c sprint : sprintList) {
      SprintWrapper wrapper = new SprintWrapper();
      wrapper.ProjectName = sprint.Project__c;
      wrapper.SprintName = sprint.Name;
      wrapper.Stories = wrappStories(storyMap.get(sprint.Id));
      sprints.add(wrapper);
    }
    return sprints;
  }

  private static List<StoriesWrapper> wrappStories(
    List<agf__ADM_Work__c> sotriesList
  ) {
    //Get the sprints form the getProjects method, then here develop the Work(Sotires) selector and leverage it on the for loop to get the related stories form the sprints

    List<StoriesWrapper> stories = new List<StoriesWrapper>();
    for (agf__ADM_Work__c story : sotriesList) {
      StoriesWrapper wrapper = new StoriesWrapper();
      wrapper.StoryId = story.Id;
      wrapper.StoryNumber = story.Name;
      wrapper.StoryTitle = story.agf__Subject__c;
      wrapper.StoryDescription = story.agf__Details__c;
      wrapper.StoryStatus = story.agf__Status__c;
      wrapper.StoryDate = story.agf__Due_Date__c;
      wrapper.StoryTeam = story.agf__Scrum_Team_Name__c;
      wrapper.StoryEpic = story.agf__Epic_Name__c;
      wrapper.StorySprint = story.agf__Sprint_Name__c;

      stories.add(wrapper);
    }
    return stories;
  }

  public class ProjectWrapper {
    @AuraEnabled
    public List<SprintWrapper> Sprints;
    @AuraEnabled
    public String ProjectNumber;
    @AuraEnabled
    public String ProjectName;
    @AuraEnabled
    public String ProjectDescription;
    @AuraEnabled
    public List<String> ProjectEpics;
  }

  public class SprintWrapper {
    @AuraEnabled
    public List<StoriesWrapper> Stories;
    @AuraEnabled
    public String SprintName;
    @AuraEnabled
    public String ProjectName;
  }

  public class StoriesWrapper {
    @AuraEnabled
    public String StoryId;
    @AuraEnabled
    public String StoryNumber;
    @AuraEnabled
    public String StoryTitle;
    @AuraEnabled
    public String StoryDescription;
    @AuraEnabled
    public String StoryStatus;
    @AuraEnabled
    public Datetime StoryDate;
    @AuraEnabled
    public String StoryTeam;
    @AuraEnabled
    public String StoryEpic;
    @AuraEnabled
    public String StorySprint;
  }
}
