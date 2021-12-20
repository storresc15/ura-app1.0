import { LightningElement, wire } from "lwc";
import getSessionInformation from "@salesforce/apex/LoginAsUserHandler.getSessionInfo";

export default class Ura_LogginToExperience extends LightningElement {
  userType;
  isLoggedInAsUser;
  hasPermission;

  @wire(getSessionInformation)
  retrieveUserSession({ error, data }) {
    if (data) {
      this.userType = data.UserType;
      this.isLoggedInAsUser = data.IsLoggedInAsUser;
      this.hasPermission = data.HasPermission;
      console.log("The user type: " + this.userType);
      console.log("Is Logged in as user?: " + this.isLoggedInAsUser);
    } else if (error) {
      console.log(error);
    }
  }
}
