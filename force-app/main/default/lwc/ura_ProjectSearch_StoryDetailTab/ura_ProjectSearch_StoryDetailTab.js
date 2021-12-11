import { track, wire, LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import { getRecord, getFieldValue } from "lightning/uiRecordApi";

// agf__ADM_Work__c Schema Imports
import BOAT_ID_FIELD from "@salesforce/schema/agf__ADM_Work__c.Id";
import BOAT_NAME_FIELD from "@salesforce/schema/agf__ADM_Work__c.Name";
const BOAT_FIELDS = [BOAT_ID_FIELD, BOAT_NAME_FIELD];
// import  from the message channel
import BOATMC from "@salesforce/messageChannel/ProjectMessageChannel__c";
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";

export default class Ura_ProjectSearch_StoryDetailTab extends NavigationMixin(
  LightningElement
) {
  // Initialize messageContext for Message Service
  @wire(MessageContext)
  messageContext;
  @track
  boatId;

  @wire(getRecord, { recordId: "$boatId", fields: BOAT_FIELDS })
  wiredRecord;

  // Decide when to show or hide the icon
  // returns 'utility:anchor' or null
  get detailsTabIconName() {
    return this.wiredRecord.data ? "utility:summary" : null;
  }

  // Utilize getFieldValue to extract the boat name from the record wire
  get boatName() {
    return getFieldValue(this.wiredRecord.data, BOAT_NAME_FIELD);
  }

  // Private
  subscription = null;

  // Subscribe to the message channel
  subscribeMC() {
    // local boatId must receive the recordId from the message
    //console.log("Inside the subscribe MC on connected Callback ----");
    if (this.subscription) {
      return;
    }
    // Subscribe to the message channel to retrieve the recordId and explicitly assign it to boatId.
    //console.log("Inside the subscribe MC on connected Callback ----");
    this.subscription = subscribe(
      this.messageContext,
      BOATMC,
      (message) => {
        this.handleMessage(message);
      },
      { scope: APPLICATION_SCOPE }
    );
  }

  handleMessage(message) {
    console.log("message : ", message);
    let receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";
    this.boatId = message.recordId;
    console.log("this.receivedMessage : ", receivedMessage);
  }

  // Calls subscribeMC()
  connectedCallback() {
    //console.log("Inside the connected Callback of Story details");
    this.subscribeMC();
  }

  // Navigates to record page
  navigateToRecordViewPage() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.boatId,
        objectApiName: "agf__ADM_Work__c",
        actionName: "view"
      }
    });
  }

  // Navigates back to the review list, and refreshes reviews component
  /*handleReviewCreated() {
        this.template.querySelector('lightning-tabset').activeTabValue = 'reviews';
        this.template.querySelector('c-boat-reviews').refresh();
    }*/
}
