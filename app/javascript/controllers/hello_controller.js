import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Este código podría interferir con el formulario si intercepta el evento `submit`
    this.element.addEventListener("submit", this.handleSubmit)
  }

  handleSubmit(event) {
    event.preventDefault() // Esto podría bloquear el envío del formulario
    // Lógica personalizada aquí
  }
}
