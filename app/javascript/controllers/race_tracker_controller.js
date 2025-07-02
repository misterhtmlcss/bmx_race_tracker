import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "atGateDisplay", 
    "inStagingDisplay", 
    "settingsPanel",
    "registrationDeadline",
    "raceStartTime",
    "registrationDisplay",
    "raceStartDisplay"
  ]

  connect() {
    this.atGate = 0
    this.inStaging = 1
    this.loadSettings()
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

  // Settings methods
  toggleSettings() {
    const panel = this.settingsPanelTarget
    panel.style.display = panel.style.display === "none" ? "block" : "none"
  }

  saveSettings(event) {
    event.preventDefault()
    
    const registrationTime = this.registrationDeadlineTarget.value
    const raceTime = this.raceStartTimeTarget.value
    
    if (registrationTime) {
      localStorage.setItem("registrationDeadline", registrationTime)
    }
    
    if (raceTime) {
      localStorage.setItem("raceStartTime", raceTime)
    }
    
    this.loadSettings()
    this.toggleSettings()
  }

  loadSettings() {
    const registrationTime = localStorage.getItem("registrationDeadline")
    const raceTime = localStorage.getItem("raceStartTime")
    
    if (registrationTime) {
      this.registrationDeadlineTarget.value = registrationTime
      this.registrationDisplayTarget.textContent = this.formatTime(registrationTime)
    }
    
    if (raceTime) {
      this.raceStartTimeTarget.value = raceTime
      this.raceStartDisplayTarget.textContent = this.formatTime(raceTime)
    }
  }

  formatTime(timeString) {
    if (!timeString) return "--:--"
    
    const [hours, minutes] = timeString.split(":")
    const hour = parseInt(hours)
    const ampm = hour >= 12 ? "PM" : "AM"
    const displayHour = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour
    
    return `${displayHour}:${minutes} ${ampm}`
  }
}