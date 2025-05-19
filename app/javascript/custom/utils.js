const BEERS = {};

const handleResponse = (beers) => {
  console.log("Handling response with", beers.length, "beers");
  BEERS.list = beers;
  BEERS.show();
};

const createTableRow = (beer) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const beername = tr.appendChild(document.createElement("td"));
  beername.innerHTML = beer.name;
  const style = tr.appendChild(document.createElement("td"));
  style.innerHTML = beer.style.name;
  const brewery = tr.appendChild(document.createElement("td"));
  brewery.innerHTML = beer.brewery.name;

  return tr;
};

BEERS.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("beertable");
  const tbody = table.querySelector("tbody");
  
  if (BEERS.list && BEERS.list.length > 0) {
    console.log("Showing", BEERS.list.length, "beers");
    BEERS.list.forEach((beer) => {
      const tr = createTableRow(beer);
      tbody.appendChild(tr);
    });
  } else {
    console.log("No beers found or empty list");
  }
};

BEERS.sortByName = () => {
  BEERS.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BEERS.sortByStyle = () => {
  BEERS.list.sort((a, b) => {
    return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
  });
};

BEERS.sortByBrewery = () => {
  BEERS.list.sort((a, b) => {
    return a.brewery.name
      .toUpperCase()
      .localeCompare(b.brewery.name.toUpperCase());
  });
};

const beers = () => {
  console.log("Beers function called");
  if (document.querySelectorAll("#beertable").length < 1) {
    console.log("No beer table found on page");
    return;
  }

  console.log("Beer table found, setting up listeners");
  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByName();
    BEERS.show();
  });

  document.getElementById("style").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByStyle();
    BEERS.show();
  });

  document.getElementById("brewery").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByBrewery();
    BEERS.show();
  });

  console.log("Fetching beers...");
  fetch("/beers.json")
    .then(response => {
      console.log("Received response:", response);
      return response.json();
    })
    .then(data => {
      console.log("Parsed data:", data.length, "beers");
      handleResponse(data);
    })
    .catch(error => {
      console.error("Error fetching beers:", error);
    });
};

export { beers };