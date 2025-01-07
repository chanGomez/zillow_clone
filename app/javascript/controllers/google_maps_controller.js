import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Google Maps controller connected!");
    this.initMap();
  }

  initMap() {
    const latitude = parseFloat(this.element.dataset.googleMapsLatitude);
    const longitude = parseFloat(this.element.dataset.googleMapsLongitude);
    const title = this.element.dataset.googleMapsTitle
    console.log(this.element.dataset);

    const map = new google.maps.Map(this.element, {
      zoom: 15,
      center: { lat: latitude, lng: longitude },
    });

    new google.maps.Marker({
      position: { lat: latitude, lng: longitude },
      map: map,
      title: title,
    });
  }
}
