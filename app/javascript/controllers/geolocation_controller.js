import { Controller } from "@hotwired/stimulus";

const options = {
  enableHighAccuracy: true,
  timeout: 17000,
  maximumAge: 0,
};


export default class extends Controller {
  connect() {
    console.log("Geolocation controller is connected for index.html.erb!");
  }

  success(pos) {
    const crd = pos.coords;

    console.log("Your current position is:");
    console.log(`Latitude : ${crd.latitude}`);
    console.log(`Longitude: ${crd.longitude}`);
    console.log(`More or less ${crd.accuracy} meters.`);

    // Reverse geocoding to get state, city, and zip code
    this.getAddressFromCoordinates(crd.latitude, crd.longitude);
  }

  error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }

  // Function to fetch address from coordinates using a reverse geocoding API
getAddressFromCoordinates(latitude, longitude) {
  const metaTag = document.querySelector('meta[name="google-maps-api-key"]');
  const apiKey = metaTag ? metaTag.content : null;

  if (!apiKey) {
    console.error("Google Maps API key not found in meta tag.");
    return;
  }

  const geocodingUrl = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=${apiKey}`;

  fetch(geocodingUrl)
    .then((response) => response.json())
    .then((data) => {
      if (data.status === "OK") {
        const results = data.results[0];
        const addressComponents = results.address_components;

        let state = "";
        let city = "";
        let zipCode = "";

        addressComponents.forEach((component) => {
          if (component.types.includes("administrative_area_level_1")) {
            state = component.long_name;
          } else if (component.types.includes("locality")) {
            city = component.long_name;
          } else if (component.types.includes("postal_code")) {
            zipCode = component.long_name;
          }
        });

        console.log("State:", state);
        console.log("City:", city);
        console.log("ZIP Code:", zipCode);

        this.searchListings(state, city, zipCode);
      } else {
        console.error("Geocoding API error:", data.status);
      }
    })
    .catch((error) => {
      console.error("Error fetching geolocation:", error);
    });
}


  // Function to trigger the search for listings based on the extracted state, city, or zip code
  searchListings(state, city, zipCode) {
    // You can now use the extracted information to search for listings.
    // For example, let's just log it for now:
    console.log("Searching listings for:", state, city, zipCode);

    // You can trigger a search action here or populate the search bar with the query:
    const searchInput = document.querySelector("#search-input"); // Make sure to have a search input field
    if (zipCode.length > 0) {
      searchInput.value = `${zipCode}`;
    }else if(city.length > 0){
      searchInput.value = `${city}`;
    }else{
      searchInput.value = `${state}`;
    }

    // Optionally, you can trigger an actual search function if you have one implemented.
    // For example, this could be an AJAX request to your listings endpoint:
    this.fetchListings(state, city, zipCode);
  }

  // Example: Function to make an AJAX call to search listings (you would define this based on your app's logic)
  fetchListings(state, city, zipCode) {
  let searchTerm = zipCode || city || state;
  
  location.assign(`/listings?search_term=${encodeURIComponent(searchTerm)}`);
}


  // The function that gets called when the user clicks the search button
  search() {
    console.log("clicked")
    navigator.geolocation.getCurrentPosition(
      this.success.bind(this),
      this.error.bind(this),
      options
    );
  }
}
