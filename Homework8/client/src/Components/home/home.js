import React, { Component } from 'react';
import { Nav, Navbar, Form, Card, Container, Row, Col, Button, Modal } from 'react-bootstrap';
import { Search } from 'semantic-ui-react';
import { FacebookIcon, TwitterIcon, EmailIcon, FacebookShareButton, TwitterShareButton, EmailShareButton } from 'react-share';
import _ from 'lodash';
import './home.css';


class Home extends Component {
    constructor() {
        super();
        this.state = {
            results: [],
            selectedResult: null,
            news: [],

            modal: {
                show: false,
                news: {
                    title: '',
                    url: null,
                }
            },
            loading: false
        }
    }

    componentDidMount() {
        fetch('/home/static')
            .then(res => res.json())
            .then(res => this.setState({ news: res.results }, () => {
                // console.log('fetched', res.results[0].multimedia[0]);
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
                {/* ************************ Navigation Bar ************************* */}
                <div id='page-main'>
                    <Navbar bg="primary" variant="dark">
                        <Search
                            onSearchChange={_.debounce(this.handleSearchChange, 1000, {
                                leading: true
                            })}
                            results={this.state.results}
                            onResultSelect={this.handleResultSelect}
                            placeholder={'Enter Keyword'}
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

                    {/* ************************ Cards ************************* */}
                    <div id="cards">
                        {this.state.news.map((news, index) =>
                            <Card key={index} border="secondary" className="text-left card">
                                <a href={news.url} className="card-link" onClick={(event) => {
                                    event.preventDefault();
                                    // console.log("onclick");
                                }}>
                                    <Container>
                                        <Row>
                                            <Col sm={3}>
                                                <Card.Img variant="top" className="card-image" src={news.multimedia && news.multimedia[0].url}></Card.Img>
                                            </Col>
                                            <Col sm={9}>
                                                <Card.Body>
                                                    <Card.Title>
                                                        {news.title}
                                                        <Button variant="light" key={index} onClick={(event) => {
                                                            event.preventDefault();
                                                            this.setState({
                                                                modal: {
                                                                    show: true,
                                                                    news: {
                                                                        title: this.state.news[index].title,
                                                                        url: this.state.news[index].url
                                                                    }
                                                                }
                                                            }, () => {
                                                                // console.log(this.state.modal);
                                                            });
                                                        }}>
                                                            Share
                                                    </Button>
                                                    </Card.Title>
                                                    <Card.Text>{news.abstract}</Card.Text>
                                                    <Container>
                                                        <Row>
                                                            <Col>
                                                                <Card.Text>
                                                                    {news.published_date.substring(0, 10)}
                                                                </Card.Text>
                                                            </Col>
                                                            <Col>
                                                                <Card bg={news.section === 'world' ? 'success' :
                                                                    news.section === 'politics' ? 'info' :
                                                                        news.section === 'business' ? 'primary' :
                                                                            news.section === 'technology' ? 'warning' :
                                                                                news.section === 'sports' ? 'danger' : 'dark'} className='card-tag'>
                                                                    <Card.Text style={{ 'textAlign': 'center' }}>{news.section}</Card.Text>
                                                                </Card>
                                                            </Col>
                                                        </Row>
                                                    </Container>
                                                </Card.Body>
                                            </Col>
                                        </Row>
                                    </Container>
                                </a>
                            </Card>
                        )}
                    </div>

                    {/* ************************ Modal ************************* */}
                    <Modal show={this.state.modal.show} onHide={() => {
                        this.setState({
                            modal: {
                                show: false,
                                news: {
                                    title: '',
                                    url: null
                                }
                            }
                        });
                    }} centered>
                        <Modal.Header closeButton>
                            <Modal.Title>{this.state.modal.news.title}</Modal.Title>
                        </Modal.Header>
                        <Modal.Body>
                            <Modal.Title className="modal-center">Share via</Modal.Title>
                            <Container>
                                <Row>
                                    <Col className="modal-center">
                                        <FacebookShareButton url={this.state.modal.news.url} hashtag={'#CSCI_571_NewsApp'}>
                                            <FacebookIcon size={64} round></FacebookIcon>
                                        </FacebookShareButton>
                                    </Col>
                                    <Col className="modal-center">
                                        <TwitterShareButton url={this.state.modal.news.url} hashtag={'#CSCI_571_NewsApp'}>
                                            <TwitterIcon size={64} round></TwitterIcon>
                                        </TwitterShareButton>
                                    </Col>
                                    <Col className="modal-center">
                                        <EmailShareButton url={this.state.modal.news.url} subject={'#CSCI_571_NewsApp'}>
                                            <EmailIcon size={64} round></EmailIcon>
                                        </EmailShareButton>
                                    </Col>
                                </Row>
                            </Container>
                        </Modal.Body>
                    </Modal>
                </div>

            </div>
        );
    };
}

export default Home;
