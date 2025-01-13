import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "form"];

  connect() {
    this.form = this.element;
  }

  submit(event) {
    event.preventDefault();
    Rails.ajax({
      url: this.form.action,
      type: "POST",
      data: new FormData(this.form),
      success: () => {
        this.inputTarget.value = ""; // Clear the input
      },
    });
  }
}
