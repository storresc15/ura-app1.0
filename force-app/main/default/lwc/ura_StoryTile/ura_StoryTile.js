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
    return "background-image:url()";
  }

  // Getter for dynamically setting the tile class based on whether the
  // current boat is selected
  get tileClass() {
    if (this.story.StoryTitle == this.selectedStoryId) {
      return TILE_WRAPPER_SELECTED_CLASS;
    }
    return TILE_WRAPPER_UNSELECTED_CLASS;
  }

  // Fires event with the Id of the boat that has been selected.
  selectBoat() {
    this.selectedStoryId = this.story.StoryTitle;
    const storyselect = new CustomEvent("storyselect", {
      detail: {
        storyId: this.selectedStoryId
      }
    });
    this.dispatchEvent(storyselect);
  }
}
