import { LightningElement, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getDashboardInfo from "@salesforce/apex/URADashboardController.getDashboardInfo";

export default class Ura_HomePage_Dashboard extends NavigationMixin(
  LightningElement
) {
  @track dashboardInfo;
  @track error;

  connectedCallback() {
    //do something
    this.getInfoFromBackend();
  }

  getInfoFromBackend() {
    getDashboardInfo({ accId: "0015e00000Ele97AAB" })
      .then((result) => {
        this.dashboardInfo = result;
        console.log(result);
      })
      .catch((error) => {
        this.error = error;
      });
  }
}
