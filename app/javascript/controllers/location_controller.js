import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["address", "latitude", "longitude", "button"]

  connect() {
    // Add a button to auto-fill coordinates from user's location
    if (this.hasButtonTarget) {
      this.buttonTarget.addEventListener("click", () => this.getUserLocation())
    }
  }

  getUserLocation() {
    if (!navigator.geolocation) {
      alert("Geolocation is not supported by your browser")
      return
    }

    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "Getting location..."

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords
        this.latitudeTarget.value = latitude.toFixed(6)
        this.longitudeTarget.value = longitude.toFixed(6)
        this.buttonTarget.disabled = false
        this.buttonTarget.textContent = "Use My Location"
      },
      (error) => {
        console.error("Geolocation error:", error)
        alert(`Unable to get your location: ${error.message}`)
        this.buttonTarget.disabled = false
        this.buttonTarget.textContent = "Use My Location"
      }
    )
  }
}
