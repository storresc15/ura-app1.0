import { api, LightningElement } from "lwc";

const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
const TILE_WRAPPER_UNSELECTED_CLASS = "tile-wrapper";

export default class Ura_StoryTile extends LightningElement {
  @api
  story;
  @api
  selectedStoryId;

  // Getter for dynamically setting the background image for the picture
  get backgroundStyle() {
    return "background-image:url(https://urast-dev-ed--c.documentforce.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Gif&versionId=0685e000004fmE6&operationContext=CHATTER&contentId=05T5e00000Q2v4a)";
  }

  // Getter for dynamically setting the tile class based on whether the
  // current boat is selected
  get tileClass() {
    console.log(
      "This is on the tile component get class method check story number:" +
        this.story.StoryId +
        " --- And the selected story: " +
        this.selectedStoryId
    );
    if (this.story.StoryId === this.selectedStoryId) {
      return TILE_WRAPPER_SELECTED_CLASS;
    }
    return TILE_WRAPPER_UNSELECTED_CLASS;
  }

  // Fires event with the Id of the boat that has been selected.
  selectBoat() {
    this.selectedStoryId = this.story.StoryId;
    console.log("On Tile component with story number: " + this.selectedStoryId);
    const storyselect = new CustomEvent("storyselect", {
      detail: {
        storyId: this.selectedStoryId
      }
    });
    this.dispatchEvent(storyselect);
  }
}
