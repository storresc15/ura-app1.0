import { LightningElement, track, wire } from "lwc";
import getProjects from "@salesforce/apex/URAProjectsController.getProjects";

export default class Ura_ProjectSearch_Form extends LightningElement {
  selectedProjectTypeId;
  selectedSprintTypeId;

  projectSprintMap = new Map();
  @track
  sprintStoryMap = new Map();

  // Private
  error = undefined;

  // Needs explicit track due to nested data
  @track
  projectOptions;
  @track
  sprintOptions;
  @track
  selectedUserStories;

  // Wire a custom Apex method
  @wire(getProjects)
  projectTypes({ data, error }) {
    console.log("The wired method is callded!");
    //console.log('Did we get any data??: ' + data);
    if (data) {
      //   console.log('This is the data: ' + this.wrappedData);
      data.map((project) => {
        return this.projectSprintMap.set(
          project.ProjectNumber,
          project.Sprints
        );
      });
      this.projectOptions = data.map((type) => {
        return { label: type.ProjectName, value: type.ProjectNumber };
      });
      this.sprintOptions = data.map((type) => {
        return {
          label: type.Sprints[0].SprintName,
          value: type.Sprints[0].SprintName
        };
      });
      //this.projectOptions.unshift({ label: 'All Projects', value: '' });
    } else if (error) {
      this.projectOptions = undefined;
      this.error = error;
    }
  }

  // Fires event that the search option has changed.
  // passes boatTypeId (value of this.selectedBoatTypeId) in the detail
  handleProjectOptionChange(event) {
    this.selectedProjectTypeId = event.detail.value;
    // Create the const searchEvent
    const searchEvent = new CustomEvent("searchProject", {
      detail: {
        TypeId: this.selectedProjectTypeId
      }
    });
    let projectSprints = this.projectSprintMap.get(this.selectedProjectTypeId);
    projectSprints.map((sprint) => {
      return this.sprintStoryMap.set(sprint.SprintName, sprint.Stories);
    });
    this.sprintOptions = projectSprints.map((type) => {
      return { label: type.SprintName, value: type.SprintName };
    });
    this.dispatchEvent(searchEvent);
    console.log("The story map at this point: " + this.sprintStoryMap);
  }

  handleSprintOptionChange(event) {
    this.selectedSprintTypeId = event.detail.value;
    // Create the const searchEvent
    const searchEvent = new CustomEvent("searchSprint", {
      detail: {
        TypeId: this.selectedSprintTypeId
      }
    });
    //let projectSprints = this.projectSprintMap.get(this.selectedProjectTypeId);
    //console.log('these are the sprints selected: ' + projectSprints);
    this.selectedUserStories = this.sprintStoryMap.get(
      this.selectedSprintTypeId
    );
    console.log("The stories: " + this.selectedUserStories);
    console.log("A sotry: " + this.selectedUserStories[0].StoryTitle);
    this.dispatchEvent(searchEvent);
  }
}
