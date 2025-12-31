import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Automatically hide the message after 3 seconds
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    // Add a fade-out effect
    this.element.style.opacity = '0'
    this.element.style.transition = 'opacity 0.5s ease'
    
    // Remove the element from DOM after transition
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}