import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "atGateDisplay", 
    "inStagingDisplay"
  ]

  connect() {
    this.atGate = 0
    this.inStaging = 1
    this.updateDisplays()
  }

  // Counter methods
  incrementAtGate() {
    if (this.atGate + 1 < this.inStaging) {
      this.atGate++
      this.updateDisplays()
    } else {
      alert("At Gate counter must be less than In Staging counter")
    }
  }

  decrementAtGate() {
    if (this.atGate > 0) {
      this.atGate--
      this.updateDisplays()
    }
  }

  incrementInStaging() {
    this.inStaging++
    this.updateDisplays()
  }

  decrementInStaging() {
    if (this.inStaging > 1 && this.inStaging - 1 > this.atGate) {
      this.inStaging--
      this.updateDisplays()
    } else if (this.inStaging <= 1) {
      alert("In Staging counter must be at least 1")
    } else {
      alert("In Staging counter must be greater than At Gate counter")
    }
  }

  updateDisplays() {
    this.atGateDisplayTarget.textContent = this.atGate
    this.inStagingDisplayTarget.textContent = this.inStaging
  }
}