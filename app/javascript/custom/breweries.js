const BREWERIES = {};

const handleResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr");
  
  const nameCell = document.createElement("td");
  nameCell.textContent = brewery.name;
  tr.appendChild(nameCell);
  
  const yearCell = document.createElement("td");
  yearCell.textContent = brewery.year;
  tr.appendChild(yearCell);
  
  const beerCountCell = document.createElement("td");
  if ('beer_count' in brewery) {
    beerCountCell.textContent = brewery.beer_count;
  } else {
    console.warn("beer_count missing for brewery:", brewery);
    beerCountCell.textContent = "?";
  }
  tr.appendChild(beerCountCell);
  
  const activeCell = document.createElement("td");
  activeCell.textContent = brewery.active ? "Yes" : "No";
  tr.appendChild(activeCell);
  
  return tr;
};

BREWERIES.show = () => {
  const tbody = document.querySelector("#brewerytable tbody");
  tbody.innerHTML = "";
  
  if (BREWERIES.list && BREWERIES.list.length > 0) {
    BREWERIES.list.forEach(brewery => {
      const row = createTableRow(brewery);
      tbody.appendChild(row);
    });
  } else {
    const row = document.createElement("tr");
    const cell = document.createElement("td");
    cell.colSpan = 4;
    cell.textContent = "No breweries found";
    row.appendChild(cell);
    tbody.appendChild(row);
  }
};

// Sorting
BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sortByYear = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year;
  });
};

BREWERIES.sortByBeerCount = () => {
  BREWERIES.list.sort((a, b) => {
    const countA = a.beer_count || 0;
    const countB = b.beer_count || 0;
    return countA - countB;
  });
};

BREWERIES.sortByActive = () => {
  BREWERIES.list.sort((a, b) => {
    if (a.active === b.active) {
      return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    }
    return b.active - a.active;
  });
};

const breweries = () => {
  if (!document.getElementById("brewerytable")) {
    return;
  }

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByName();
    BREWERIES.show();
  });
  
  document.getElementById("year").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByYear();
    BREWERIES.show();
  });
  
  document.getElementById("beers").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByBeerCount();
    BREWERIES.show();
  });
  
  document.getElementById("active").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByActive();
    BREWERIES.show();
  });
  
  fetch("/breweries.json")
    .then(response => response.json())
    .then(data => {

      
      handleResponse(data);
    })
    .catch(error => {
      console.error("Error fetching breweries:", error);
    });
};

export { breweries };