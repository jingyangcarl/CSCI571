import React, { Component } from 'react';
import { Nav, Navbar, Form } from 'react-bootstrap';
import { Search } from 'semantic-ui-react';
import _ from 'lodash';
import './home.css';


class Home extends Component {
    constructor() {
        super();
        this.state = {
            results: [], 
            selectedResult: null,
            news: [],
        }
    }

    componentDidMount() {
        fetch('/home')
            .then(res => res.json())
            .then(res => this.setState({news: res.results}, () => {
                console.log('fetched', res);
            }));
    }

    handleResultSelect = (e, { result }) =>
      this.setState({ selectedResult: result });
  
    handleSearchChange = async (event, { value }) => {
      try {
        const response = await fetch(
          `https://api.cognitive.microsoft.com/bing/v7.0/suggestions?mkt=fr-FR&q=${value}`,
          {
            headers: {
              "Ocp-Apim-Subscription-Key": "79f5b5a589c74be4aa1d102ca11fadd2"
            }
          }
        );
        const data = await response.json();
        const resultsRaw = data.suggestionGroups[0].searchSuggestions;
        const results = resultsRaw.map(result => ({
          title: result.displayText,
          url: result.url
        }));
        this.setState({ results });
      } catch (error) {
        console.error(`Error fetching search ${value}`);
      }
    };

    render() {
        return (
            <div>
                <Navbar bg="primary" variant="dark">
                    <Search
                        onSearchChange={_.debounce(this.handleSearchChange, 1000, {
                            leading: true
                        })}
                        results={this.state.results}
                        onResultSelect={this.handleResultSelect}
                    />
                    <Nav>
                        <Nav.Item>
                            <Nav.Link href="/home">Home</Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link
                                eventKey="world"
                                onSelect={value => this.onSelect_fetch(value)}
                            >
                                World
                            </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link
                                eventKey="politics"
                                onSelect={value => this.onSelect_fetch(value)}
                            >
                                Politics
                            </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link
                                eventKey="business"
                                onSelect={value => this.onSelect_fetch(value)}
                            >
                                Business
                            </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link
                                eventKey="technology"
                                onSelect={value => this.onSelect_fetch(value)}
                            >
                                Technology
                            </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link
                                eventKey="sports"
                                onSelect={value => this.onSelect_fetch(value)}
                            >
                                Sports
                            </Nav.Link>
                        </Nav.Item>
                    </Nav>
                    <Nav className="ml-auto">
                        <Nav.Item>
                            <Nav.Link>NYTimes</Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Form.Switch label="" />
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link>Guardian</Nav.Link>
                        </Nav.Item>
                    </Nav>
                </Navbar>
                <div>
                    <ul>
                        {this.state.news.map(news => 
                                <li>{news.url}</li>
                        )}
                    </ul>
                </div>
            </div>
        );
    };
}

export default Home;
