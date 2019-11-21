import "bootstrap";
import "jquery";

const options = document.querySelectorAll("option");

if (options) {
    const arrayOfOptions = Array.from(options);
    const theOption = arrayOfOptions.filter((option) => {
        if (findGetParameter("country")) {
            return option.value === findGetParameter("country");
        } else {
            return option.value === "All";
        }
    })
    theOption[0].selected = true;
}

function findGetParameter(parameterName) {
    let result = null;
    let tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach((item) => {
          tmp = item.split("=");
          if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
};


// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart']});

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChart);


const graphInfos = document.querySelector(".graph").dataset.infos

function drawChart() {
    const dataValues = JSON.parse(graphInfos);
    const allValues = [["Month", "Revenue per month", {role: 'style'}]];
    dataValues.forEach((d) => {
        const valueToIntegrate = [
            d.date_year_month,
            d.monthly_revenue,
            'color: rgb(3, 152, 145)'
        ];
        allValues.push(valueToIntegrate);
    });
    const data = google.visualization.arrayToDataTable(allValues);
    const options = {'title':'Revenue per month',
                        'width':1200,
                        'height':500,
                        legend: { position: "none" }};

    const chart = new google.visualization.ColumnChart(document.querySelector(".graph"));

    chart.draw(data, options);
};


