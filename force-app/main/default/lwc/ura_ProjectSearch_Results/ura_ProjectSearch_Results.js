import { api, LightningElement, track, wire } from "lwc";
import { publish, MessageContext } from "lightning/messageService";
//import { refreshApex } from '@salesforce/apex';

//import getBoats from '@salesforce/apex/BoatDataService.getBoats';
//import updateBoatList from '@salesforce/apex/BoatDataService.updateBoatList';
import BOATMC from "@salesforce/messageChannel/ProjectMessageChannel__c";

export default class Ura_ProjectSearch_Results extends LightningElement {
  @api
  selectedBoatId;

  boatTypeId = "";
  @api
  stories;
  @track
  boats;
  isLoading = false;

  // wired message context
  @wire(MessageContext)
  messageContext;

  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api
  searchBoats(boatTypeId) {
    this.isLoading = true;
    this.notifyLoading(this.isLoading);
    this.boatTypeId = boatTypeId;
  }

  // this public function must refresh the boats asynchronously
  // uses notifyLoading

  // this function must update selectedBoatId and call sendMessageService
  updateSelectedTile(event) {
    this.selectedBoatId = event.detail.storyId;
    console.log("The selected story id: " + this.selectedBoatId);
    this.sendMessageService(this.selectedBoatId);
  }

  // Publishes the selected boat Id on the BoatMC.
  sendMessageService(boatId) {
    // explicitly pass boatId to the parameter recordId
    console.log("Sending this message with record id: " + boatId);
    publish(this.messageContext, BOATMC, { recordId: boatId });
  }

  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) {
    if (isLoading) {
      this.dispatchEvent(new CustomEvent("loading"));
    } else {
      this.dispatchEvent(CustomEvent("doneloading"));
    }
  }
}
