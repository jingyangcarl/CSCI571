import React, { Component } from 'react';
import { Nav, Navbar, Card, Container, Row, Col, Button, Modal, Spinner, CardColumns } from 'react-bootstrap';
import { Search } from 'semantic-ui-react';
import { FacebookIcon, TwitterIcon, EmailIcon, FacebookShareButton, TwitterShareButton, EmailShareButton } from 'react-share';
import { IoMdShare } from 'react-icons/io';
// import AsyncSelect from 'react-select/async';
import Switch from 'react-switch';
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

            // if the switch is checked or not
            checked: localStorage.getItem('checked') === 'true' ? true : false,
        };
        this.shareButtonClicked = false;
        this.handleSwitchChange = this.handleSwitchChange.bind(this);
    }

    componentDidMount() {

        this.removeCommentBox = commentBox('5651135952060416-proj');

        fetch('', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                source: this.state.checked ? 'guardian' : 'nytimes'
            })
        })
            .then(res => res.json())
            .then(res => this.setState({ news: this.state.checked ? res.response.results : res.results }, () => {
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

    /*
    Description:
    This function is used to handle Switch onChange functions;
    */
    async handleSwitchChange(checked) {

        try {
            // set current switch status
            this.setState({ checked });

            // show loading page
            document.getElementById("page-loading").style.display = "block";

            // hide other pages and save page hiding status
            var show_page_cards = document.getElementById('page-cards').style.display;
            var show_page_search = document.getElementById('page-search').style.display;
            var show_page_detail = document.getElementById('page-detail').style.display;
            document.getElementById('page-cards').style.display = "none";
            document.getElementById('page-search').style.display = "none";
            document.getElementById('page-detail').style.display = "none";

            // get data from backend server
            const response = await fetch('', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    source: checked ? 'guardian' : 'nytimes'
                })
            });
            const data = await response.json();

            // set status
            this.setState({ news: (checked ? data.response.results /* guardian */ : data.results /* nytimes */) });

            // hide loading page
            document.getElementById("page-loading").style.display = "none";

            // recover page hiding status
            document.getElementById('page-cards').style.display = show_page_cards;
            document.getElementById('page-search').style.display = show_page_search;
            document.getElementById('page-detail').style.display = show_page_detail;

            // set local status
            localStorage.setItem('checked', Boolean(checked));
        } catch (error) {

        }
    }

    render() {
        return (
            <div>
                {/* ************************ Navigation Bar ************************* */}

                <Navbar bg="primary" variant="dark" style={{background: 'linear-gradient(90deg, rgba(20,41,75,1) 0%, rgba(50,77,132,1) 50%, rgba(76,108,183,1) 100%)'}}>
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
                            <Switch uncheckedIcon={false} checkedIcon={false} onChange={this.handleSwitchChange} checked={this.state.checked}></Switch>
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
                    {this.state.news && this.state.news.map((news, index) =>
                        <Card key={index} border="secondary" className="text-left card">
                            <a href={news &&
                                (this.state.checked ?
                                    news.webUrl /* guardian */ :
                                    news.url /* nytimes */)}
                                className="card-link"
                                onClick={(event) => {
                                    event.preventDefault();
                                    if (this.shareButtonClicked) {
                                        // button clicked
                                    } else {
                                        // link clicked

                                        // fetch for details
                                        fetch('/home/detail', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/json' },
                                            body: JSON.stringify({
                                                source: this.state.checked ? 'guardian' : 'nytimes',
                                                url:
                                                    (this.state.checked ?
                                                        this.state.news[index].id /* guardian */ :
                                                        this.state.news[index].url /* nytimes */)
                                            })
                                        })
                                            .then(res => res.json())
                                            .then(res => this.setState({
                                                news_detail:
                                                    (this.state.checked ?
                                                        res.response.content /* guardian */ :
                                                        res.response.docs[0] /* nytimes */)
                                            }, () => {
                                                // show results after fetching
                                                document.getElementById("page-loading").style.display = "none";
                                                document.getElementById("page-detail").style.display = "block";
                                                console.log(this.state.news_detail);
                                            }));
                                        // show loading page
                                        document.getElementById('page-cards').style.display = "none";
                                        document.getElementById("page-loading").style.display = "block";
                                    }
                                }}>
                                <Container>
                                    <Row>
                                        <Col sm={3}>
                                            {/* TODO: Only the first image URL with width >= 2000 is to be used. If no such URLs are found, a default image for NY Times News is to be displayed. */}
                                            <Card.Img className="card-image" src={news &&
                                                (this.state.checked ?
                                                    (news.blocks && news.blocks.main && (news.blocks.main.elements[0].assets[0] ?
                                                        news.blocks.main.elements[0].assets[0].file :
                                                        'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png') /* guardian */) :
                                                    (news.multimedia && (news.multimedia[0] ?
                                                        news.multimedia[0].url :
                                                        'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg') /* nytimes */))}></Card.Img>
                                        </Col>
                                        <Col sm={9}>
                                            <Card.Body>
                                                <Card.Title>
                                                    {news && (this.state.checked ? news.webTitle : news.title)}
                                                    <Button variant="link" key={index} onClick={(event) => {
                                                        event.preventDefault();
                                                        this.setState({
                                                            // TODO: URLs should be modified
                                                            modal: {
                                                                show: true,
                                                                news: {
                                                                    title: (this.state.checked ?
                                                                        this.state.news[index].webTitle /* guardian */ :
                                                                        this.state.news[index].title /* nytimes */),
                                                                    url: (this.state.checked ?
                                                                        this.state.news[index].webUrl /* guardian */ :
                                                                        this.state.news[index].url/* nytimes */)
                                                                }
                                                            }
                                                        });
                                                        this.shareButtonClicked = true;
                                                    }}>
                                                        <IoMdShare></IoMdShare>
                                                    </Button>
                                                </Card.Title>
                                                <Card.Text>
                                                    {/* TODO: In the article description, no words should be cut in the middle and there MUST be the ellipsis whenever needed (limit to 3 lines) */}
                                                    {news && (this.state.checked ?
                                                        news.blocks && news.blocks.body[0].bodyTextSummary && (news.blocks.body[0].bodyTextSummary.length > 200 ?
                                                            news.blocks.body[0].bodyTextSummary.substring(0, 200) + '...' :
                                                            news.blocks.body[0].bodyTextSummary) /* guardian */ :
                                                        news.abstract && (news.abstract.length > 200 ?
                                                            news.abstract.substring(0, 200 + '...') :
                                                            news.abstract) /* nytimes */)}
                                                </Card.Text>
                                                <Container>
                                                    <Row>
                                                        <Col>
                                                            <Card.Text>
                                                                {news &&
                                                                    (this.state.checked ?
                                                                        (news.webPublicationDate && news.webPublicationDate.substring(0, 10) /* guardian */) :
                                                                        (news.published_date && news.published_date.substring(0, 10) /* nytimes */))}
                                                            </Card.Text>
                                                        </Col>
                                                        <Col>
                                                            <Card style={news && (this.state.checked ?
                                                                /* guardian */
                                                                (news.sectionId === 'world' ? { background: '#7C4EFF', color: 'white' } :
                                                                    news.sectionId === 'politics' ? { background: '#419488', color: 'white' } :
                                                                        news.sectionId === 'business' ? { background: '#4696EC', color: 'white' } :
                                                                            news.sectionId === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                                                                news.sectionId === 'sport' ? { background: '#F6C245', color: 'black' } : { background: '#6E757C', color: 'white' }) :
                                                                /* nytimes */
                                                                (news.section === 'world' ? { background: '#7C4EFF', color: 'white' } :
                                                                    news.section === 'politics' ? { background: '#419488', color: 'white' } :
                                                                        news.section === 'business' ? { background: '#4696EC', color: 'white' } :
                                                                            news.section === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                                                                news.section === 'sports' ? { background: '#F6C245', color: 'black' } : { background: '#6E757C', color: 'white' }))}
                                                                className='card-tag'>
                                                                <Card.Text style={{ 'textAlign': 'center' }}>
                                                                    {news && (this.state.checked ?
                                                                        (news.sectionId && news.sectionId.toUpperCase() /* guardian */) :
                                                                        (news.section && news.section.toUpperCase() /* nytimes */))}
                                                                </Card.Text>
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
                    <CardColumns>
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
                                                    <Button variant={search.news_desk === 'world' ? 'success' :
                                                        search.news_desk === 'politics' ? 'info' :
                                                            search.news_desk === 'business' ? 'primary' :
                                                                search.news_desk === 'technology' ? 'warning' :
                                                                    search.news_desk === 'sports' ? 'danger' : 'dark'} size="sm" className='search-tag'>
                                                        {search.news_desk}
                                                    </Button>
                                                </Col>
                                            </Row>
                                        </Container>
                                    </Container>
                                </a>
                            </Card>
                        )}
                    </CardColumns>

                </div>

                {/* *************** Detail Page *************** */}
                <div id="page-detail" className="page-detail">
                    <Card className="card">
                        <Container>
                            <Row className="card-row">
                                <Col>
                                    <Card.Title>{this.state.news_detail &&
                                        (this.state.checked ?
                                            this.state.news_detail.webTitle : /* guardian */
                                            this.state.news_detail.headline.main /* nytimes */)}
                                    </Card.Title>
                                </Col>
                            </Row>
                            <Row>
                                <Col>
                                    <Card.Text>
                                        {this.state.news_detail &&
                                            (this.state.checked ?
                                                (this.state.news_detail.webPublicationDate && this.state.news_detail.webPublicationDate.substring(0, 10)) : /* guardian */
                                                (this.state.news_detail.pub_date && this.state.news_detail.pub_date.substring(0, 10)) /* nytimes */)}
                                    </Card.Text>
                                </Col>
                                <Col>
                                    <FacebookShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} hashtag={'#CSCI_571_NewsApp'}>
                                        <FacebookIcon size={16} round></FacebookIcon>
                                    </FacebookShareButton>
                                    <TwitterShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} hashtag={'#CSCI_571_NewsApp'}>
                                        <TwitterIcon size={16} round></TwitterIcon>
                                    </TwitterShareButton>
                                    <EmailShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} subject={'#CSCI_571_NewsApp'}>
                                        <EmailIcon size={16} round></EmailIcon>
                                    </EmailShareButton>
                                </Col>
                            </Row>
                            <Row className="card-row">
                                <Card.Img src={this.state.news_detail &&
                                    (this.state.checked ?
                                        (this.state.news_detail.blocks.main.elements && this.state.news_detail.blocks.main.elements[0].assets && (this.state.news_detail.blocks.main.elements[0].assets[0] ?
                                            this.state.news_detail.blocks.main.elements[0].assets[0].file :
                                            'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png')) : /* guardian */
                                        (this.state.news_detail.multimedia && (this.state.news_detail.multimedia[0] ?
                                            'http://static01.nyt.com/' + this.state.news_detail.multimedia[0].url :
                                            'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg' /* nytimes */)))}></Card.Img>
                            </Row>
                            <Row className="card-row">
                                <Col>
                                    <Card.Text>
                                        {this.state.news_detail &&
                                            (this.state.checked ?
                                                this.state.news_detail.blocks.body && this.state.news_detail.blocks.body[0].bodyTextSummary : /* guardian */
                                                this.state.news_detail.abstract /* nytimes */)}
                                    </Card.Text>
                                </Col>
                            </Row>
                        </Container>
                    </Card>
                    <div className="commentbox"></div>
                </div>
            </div >
        );
    };
}

export default Home;
