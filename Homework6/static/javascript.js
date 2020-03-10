function onload_fetch_headlines() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // add retrived cards 
            var jsonobj = JSON.parse(this.response);
            var card_to_load = 4;
            document.getElementById('gn_cnn_table').innerHTML += '<tr>';
            for (var i = 0; i < jsonobj.articles.length; i++) {
                if (card_to_load <= 0) break;
                if (!jsonobj.articles[i]['url']) continue;
                if (!jsonobj.articles[i]['urlToImage']) continue;
                if (!jsonobj.articles[i]['title']) continue;
                if (!jsonobj.articles[i]['description']) continue;

                var table_item =
                    '<td>' +
                    '<div class="card">' +
                    '<a href=' + jsonobj.articles[i]['url'] + ' target="_blank">' +
                    //'<img src="' + jsonobj.articles[i]['urlToImage'] + '" style="width: 100%;">' +
                    '<div class="card_container">' +
                    '<h3>' +
                    '<b>' + jsonobj.articles[i]['title'] + '</b>' +
                    '</h3>' +
                    '<p>' + jsonobj.articles[i]['description'] + '</p>' +
                    '</div>' +
                    '</a>' +
                    '</div>' +
                    '</td>';
                document.getElementById('gn_cnn_table').innerHTML += table_item;
                card_to_load--;
            }
            document.getElementById('gn_cnn_table').innerHTML += '</tr>';
        }
    }
    xhttp.open("GET", '/fetch_headlines/cnn', true);
    xhttp.send();
}

function onclick_show(event, tabcontent_id) {
    var tabcontents = document.getElementsByClassName("header-tabcontent");
    for (i = 0; i < tabcontents.length; i++) {
        tabcontents[i].style.display = "none";
    }
    var tabcontent_toshow = document.getElementById(tabcontent_id);
    tabcontent_toshow.style.display = "block";
}

function onchange_fetch_source(selectedObject) {

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // remove old options
            options_previous = document.getElementById('search_select_source').getElementsByTagName('option');
            while (options_previous.length > 0) {
                options_previous[0].parentNode.removeChild(options_previous[0]);
            }

            // add default option
            var node_option = document.createElement('option');
            node_option.appendChild(document.createTextNode('all'));
            document.getElementById('search_select_source').appendChild(node_option);

            // add retrived options
            var jsonobj = JSON.parse(this.response);
            for (var i = 0; i < jsonobj.sources.length; i++) {
                var node_option = document.createElement('option');
                node_option.appendChild(document.createTextNode(jsonobj.sources[i]['id']));
                document.getElementById('search_select_source').appendChild(node_option);
            }
        }
    }

    var category = selectedObject.value;
    xhttp.open("GET", '/fetch_source/' + category, true);
    xhttp.send();
}

function onsubmit_search(event) {
    event.preventDefault();

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // remove all the old <tr>
            cards_previous = document.getElementById('result_result_cards').getElementsByTagName('tr');
            while (cards_previous.length > 0) {
                cards_previous[0].parentNode.removeChild(cards_previous[0]);
            }

            // add retrived cards
            var jsonobj = JSON.parse(this.response);
            for (var i = 0; i < jsonobj.articles.length; i++) {
                if (!jsonobj.articles[i]['url']) continue;
                if (!jsonobj.articles[i]['urlToImage']) continue;
                if (!jsonobj.articles[i]['title']) continue;
                if (!jsonobj.articles[i]['description']) continue;

                var option_source_item =
                    '<tr>' +
                    '<td>' +
                    '<div class="card">' +
                    '<a href=' + jsonobj.articles[i]['url'] + ' target="_blank">' +
                    '<img src="' + jsonobj.articles[i]['urlToImage'] + '" style="width: 100%;">' +
                    '<div class="card_container">' +
                    '<h3>' +
                    '<b>' + jsonobj.articles[i]['title'] + '</b>' +
                    '</h3>' +
                    '<p>' + jsonobj.articles[i]['description'] + '</p>' +
                    '</div>' +
                    '</a>' +
                    '</div>' +
                    '</td>' +
                    '</tr>';
                document.getElementById('result_result_cards').innerHTML += option_source_item;
            }
        }
    }
    xhttp.open("POST", '/search', true);
    xhttp.send(new FormData(document.getElementById('search_form')));
}