/*
Description:
This function is used to 
Input:

Output:

*/
function viewJSON(what){
    var URL = what.URL.value;

    if (URL==null || URL=="") {
        window.alert("Please input a file name!");
        return;
    }

    /*
    Description:
    This function is used to load JSON file from a given URL;
    Input:
    @ URL: a given URL;
    Output:
    @ jsonOBJ: a json object;
    */
    function loadJSON(URL) {
        var xmlhttp = new XMLHttpRequest();
        // open, send, responseText are properties of XMLHTTPRequest
        URL = "/Users/jyang/Documents/Project/CSCI571/Homework4/buildinglist.json"
        xmlhttp.open("GET", URL, false)
        try {
            xmlhttp.send();
        } catch (error){
            throw "File not Found!";
            return;
        }

        jsonOBJ = JSON.parse(xmlhttp.responseText);
        return jsonOBJ;
    }

    try {
        jsonOBJ = loadJSON(URL);
        jsonOBJ.onload = generateHTML(jsonOBJ);
        windowHandle = window.open("", "Largest Manufactures by Production (2017)", "height=1000, width=1200");
        windowHandle.document.write(htmlText);
        windowHandle.document.close();
    } catch (error){
        window.alert(error)
    }
}

function generateHTML(jsonOBJ) {
    root = jsonOBJ.DocumentElement;
    htmlText = "<html><head><title>JSON Parse Result</title></head><body>";
    htmlText += "<table border='2'>";
    if (jsonOBJ.Mainline.Table.Row == null) {
        throw "Empty"
    }
    buildings = jsonOBJ.Mainline.Table.Row; // an array of buildings
    buildingNodeList = buildings[0];
    htmlText += "<tbody>";
    htmlText += "<tr>";
    x = 200; y = 200;

    // output the headers
    var header_keys = jsonObj.Mainline.Table.Header.Data;
    for (i = 0; i < header_keys.length; i++) {
        header = header_keys[i];
        htmlText += "<th>"+header+"</th>";
    }
    htmlText+="</tr>";

    // output the values
    for (i = 0; i < buildings.length; i++){
        // get properties of a plane (an object)
        buildingNodeList = buildings[i];
        // start a new row of the output table
        htmlText+="<tr>";
        if (buildingNodeList == null){
            continue;
        } else {
            var building_keys = Object.keys(buildingNodeList);
        }
        for (j = 0; j < building_keys.length; j++) {
            prop = building_keys[j];
            if (buildingNodeList[j] == "Logo") {
                if (buildingNodeList[prop] == null){
                    htmlText += "<td></td>";
                } else {
                    htmlText += "<td><img src='" + buildingNodeList[prop] + "' width='" + x + "' height='" + y + "'></td>";
                }
            } else if (buildingNodeList[j] == "HomePage") {
                if (buildingNodeList[prop] = null){
                    htmlText += "<td></td>";
                } else {
                    htmlText += "<td><a href='" + buildingNodeList[prop] + "'>"+ buildingNodeList[prop] + "</a></td>";
                }
            } else if (buildingNodeList[j] == "Hubs") {

            } else {
                
            }
        }
    }
}