import React, { Component } from 'react';
import { Nav, Navbar, Form, Card, Container, Row, Col, Button, Modal, Spinner } from 'react-bootstrap';
import { Search } from 'semantic-ui-react';
import { FacebookIcon, TwitterIcon, EmailIcon, FacebookShareButton, TwitterShareButton, EmailShareButton } from 'react-share';
import { IoMdShare } from 'react-icons/io';
import commentBox from 'commentbox.io';
import _ from 'lodash';
import './home.css';


class Home extends Component {
    constructor() {
        super();
        this.state = {
            results: [],
            selectedResult: null,

            news: [],
            news_detail: null,

            searches: [],

            modal: {
                show: false,
                news: {
                    title: '',
                    url: null,
                }
            },

        };
        this.shareButtonClicked = false;
    }

    componentDidMount() {

        this.removeCommentBox = commentBox('5651135952060416-proj');

        fetch('')
            .then(res => res.json())
            .then(res => this.setState({ news: res.results }, () => {
                document.getElementById('page-cards').style.display = "block";
                document.getElementById("page-loading").style.display = "none";
            }));
        document.getElementById('page-cards').style.display = "none";
        document.getElementById("page-loading").style.display = "block";
    }

    componentWillUnmount() {
        this.removeCommentBox();
    }

    handleResultSelect = (e, { result }) => {
        this.setState({ selectedResult: result });
        fetch('/keyword/' + result.title)
            .then(res => res.json())
            .then(res => this.setState({ searches: res.response.docs }, () => {
                document.getElementById('page-search').style.display = "block";
                document.getElementById("page-loading").style.display = "none";
            }));
        document.getElementById('page-cards').style.display = "none";
        document.getElementById("page-loading").style.display = "block";
    };

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
                <Navbar bg="primary" variant="dark">
                    <Search
                        onSearchChange={_.debounce(this.handleSearchChange, 1000, {
                            leading: true
                        })}
                        results={this.state.results}
                        onResultSelect={this.handleResultSelect}
                        placeholder={'Enter Keyword'}
                    />
                    <Nav defaultActiveKey="/home">
                        <Nav.Item>
                            <Nav.Link eventKey="home" href="/home"> Home </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="world" href="/section/world"> World </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="politics" href="/section/politics"> Politics </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="business" href="/section/business"> Business </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="technology" href="/section/technology"> Technology </Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="sports" href="/section/sports"> Sports </Nav.Link>
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


                {/* *************** Loading Page *************** */}
                {/* ***** Spinner ***** */}
                <div id="page-loading" className="page-loading">
                    <Spinner animation="grow" variant="primary"></Spinner>
                    <p>Loading</p>
                </div>

                {/* *************** Card Page *************** */}
                {/* ***** Cards ***** */}
                <div id="page-cards">
                    {this.state.news.map((news, index) =>
                        <Card key={index} border="secondary" className="text-left card">
                            <a href={news.url} className="card-link" onClick={(event) => {
                                event.preventDefault();
                                if (this.shareButtonClicked) {
                                    // button clicked
                                } else {
                                    // link clicked
                                    fetch('/home/detail', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify({
                                            url: this.state.news[index].url
                                        })
                                    })
                                        .then(res => res.json())
                                        .then(res => this.setState({ news_detail: res.response.docs[0] }, () => {
                                            document.getElementById("page-loading").style.display = "none";
                                            document.getElementById("page-detail").style.display = "block";
                                        }));
                                    document.getElementById('page-cards').style.display = "none";
                                    document.getElementById("page-loading").style.display = "block";
                                }
                            }}>
                                <Container>
                                    <Row>
                                        <Col sm={3}>
                                            <Card.Img className="card-image" src={news.multimedia && news.multimedia[0].url}></Card.Img>
                                        </Col>
                                        <Col sm={9}>
                                            <Card.Body>
                                                <Card.Title>
                                                    {news.title}
                                                    <Button variant="link" key={index} onClick={(event) => {
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
                                                        this.shareButtonClicked = true;
                                                    }}>
                                                        <IoMdShare></IoMdShare>
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

                    {/* ***** Modal ***** */}
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
                        this.shareButtonClicked = false;
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

                {/* *************** Search Results Page *************** */}
                <div id="page-search" className="page-search">
                    {this.state.searches.map((search, index) =>
                        <Card key={index} border="secondary" className="text-left card card-search">
                            <a href={search.url} className="card-link" onClick={() => {

                            }}>
                                <Container>
                                    <Row>
                                        <Col>
                                            <Card.Title>
                                                {search.headline && search.headline.main}
                                                <Button variant="link" key={index} onClick={(event) => {
                                                    event.preventDefault();
                                                    this.setState({
                                                        modal: {
                                                            show: true,
                                                            news: {
                                                                title: this.state.search[index].headline.main,
                                                                url: this.state.search[index].url
                                                            }
                                                        }
                                                    }, () => {

                                                    });
                                                    this.shareButtonClicked = true;
                                                }}>
                                                    <IoMdShare></IoMdShare>
                                                </Button>
                                            </Card.Title>
                                        </Col>
                                    </Row>
                                    <Row>
                                        <Card.Text></Card.Text>
                                        <Card.Img src={search.multimedia && search.multimedia[0] && 'http://static01.nyt.com/' + search.multimedia[0].url}></Card.Img>
                                    </Row>
                                    <Container>
                                        <Row>
                                            <Col>
                                                <Card.Text>{search.pub_date && search.pub_date.substring(0, 10)}</Card.Text>
                                            </Col>
                                            <Col>
                                                <Card bg={search.news_desk === 'world' ? 'success' :
                                                    search.news_desk === 'politics' ? 'info' :
                                                        search.news_desk === 'business' ? 'primary' :
                                                            search.news_desk === 'technology' ? 'warning' :
                                                                search.news_desk === 'sports' ? 'danger' : 'dark'} className='card-tag'>
                                                    <Card.Text style={{ 'textAlign': 'center' }}>{search.news_desk}</Card.Text>
                                                </Card>
                                            </Col>
                                        </Row>
                                    </Container>
                                </Container>

                            </a>
                        </Card>
                    )}
                </div>

                {/* *************** Detail Page *************** */}
                <div id="page-detail" className="page-detail">
                    <Card className="card">
                        <Container>
                            <Row className="card-row">
                                <Col>
                                    <Card.Title>{this.state.news_detail && this.state.news_detail.headline.main}</Card.Title>
                                </Col>
                            </Row>
                            <Row>
                                <Col>
                                    <Card.Text>
                                        {this.state.news_detail && this.state.news_detail.pub_date.substring(0, 10)}
                                    </Card.Text>
                                </Col>
                                <Col>
                                    <FacebookShareButton url={this.state.news_detail && this.state.news_detail.web_url} hashtag={'#CSCI_571_NewsApp'}>
                                        <FacebookIcon size={16} round></FacebookIcon>
                                    </FacebookShareButton>
                                    <TwitterShareButton url={this.state.news_detail && this.state.news_detail.web_url} hashtag={'#CSCI_571_NewsApp'}>
                                        <TwitterIcon size={16} round></TwitterIcon>
                                    </TwitterShareButton>
                                    <EmailShareButton url={this.state.news_detail && this.state.news_detail.web_url} subject={'#CSCI_571_NewsApp'}>
                                        <EmailIcon size={16} round></EmailIcon>
                                    </EmailShareButton>
                                </Col>
                            </Row>
                            <Row className="card-row">
                                <Card.Img src={this.state.news_detail && this.state.news_detail.multimedia[0] && 'http://static01.nyt.com/' + this.state.news_detail.multimedia[0].url}></Card.Img>
                            </Row>
                            <Row className="card-row">
                                <Col>
                                    <Card.Text>
                                        {this.state.news_detail && this.state.news_detail.abstract}
                                    </Card.Text>
                                </Col>
                            </Row>
                        </Container>
                    </Card>
                    <div className="commentbox"></div>
                </div>
            </div>
        );
    };
}

export default Home;
