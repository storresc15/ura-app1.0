import { LightningElement, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getDashboardInfo from "@salesforce/apex/URADashboardController.getDashboardInfo";

export default class Ura_HomePage_Dashboard extends NavigationMixin(
  LightningElement
) {
  @track dashboardInfo;
  @track error;
  @track hasProjects;

  connectedCallback() {
    //do something
    this.getInfoFromBackend();
  }

  getInfoFromBackend() {
    getDashboardInfo()
      .then((result) => {
        this.dashboardInfo = result;
        console.log(result);
        if (this.dashboardInfo.projectsInfo.length <= 0) {
          this.hasProjects = false;
        } else {
          this.hasProjects = true;
        }
        console.log(
          "Size of the projects: " + this.dashboardInfo.projectsInfo.length
        );
        console.log("Has projects: " + this.hasProjects);
      })
      .catch((error) => {
        this.error = error;
      });
  }
}
