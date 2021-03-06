import React, { Component } from 'react';
import { Nav, Navbar, Card, Container, Row, Col, Button, Modal, Spinner, CardColumns, Tooltip, OverlayTrigger, Toast, Accordion, NavItem } from 'react-bootstrap';
import { Search } from 'semantic-ui-react';
import { FacebookIcon, TwitterIcon, EmailIcon, FacebookShareButton, TwitterShareButton, EmailShareButton } from 'react-share';
import { MdShare, MdDelete, MdMenu, MdBookmarkBorder } from 'react-icons/md';
import Switch from 'react-switch';
import commentBox from 'commentbox.io';
import _ from 'lodash';
import './App.css';

class App extends Component {
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

      toast: {
        show: false,
        content: null
      },

      // if the switch is checked or not
      checked: localStorage.getItem('switch_checked') === 'true' ? true : false,
    };
    this.isMobile = window.innerWidth <= 500;

    this.shareButtonClicked = false;
    this.deleteButtonClicked = false;
    this.bookmarkButtonClicked = false;

    this.handleSwitchChange = this.handleSwitchChange.bind(this);
    this.handleBookMarkClicked = this.handleBookMarkClicked.bind(this);
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
        document.getElementById('navbar-switch').style.display = "float";
        document.getElementById('page-loading').style.display = "none";
      }));
    document.getElementById('page-cards').style.display = "none";
    document.getElementById('page-loading').style.display = "block";
  }

  componentWillUnmount() {
    this.removeCommentBox();
  }

  handleResultSelect = (e, { result }) => {
    this.setState({ selectedResult: result });
    fetch('/keyword/' + result.title, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        source: this.state.checked ? 'guardian' : 'nytimes'
      })
    })
      .then(res => res.json())
      .then(res => this.setState({
        searches: (this.state.checked ?
          res.response.results /* guardian */ :
          res.response.docs /* nytimes */)
      }, () => {
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
      localStorage.setItem('switch_checked', Boolean(checked));
    } catch (error) {

    }
  }

  handleBookMarkClicked() {

    if (this.bookmarkButtonClicked) {
      // bookmark page is current page

      // hid bookmark page
      document.getElementById('page-bookmark').style.display = "none";
      this.bookmarkButtonClicked = false;

      // recover other pages
      document.getElementById('page-cards').style.display = localStorage.getItem('show_page_cards');
      document.getElementById('page-search').style.display = localStorage.getItem('show_page_search');
      document.getElementById('page-detail').style.display = localStorage.getItem('show_page_detail');
      document.getElementById('page-loading').style.display = localStorage.getItem('show_page_loading');


    } else {
      // bookmark page is not current page

      // save page hiding status
      localStorage.setItem('show_page_cards', document.getElementById('page-cards').style.display);
      localStorage.setItem('show_page_search', document.getElementById('page-search').style.display);
      localStorage.setItem('show_page_detail', document.getElementById('page-detail').style.display);
      localStorage.setItem('show_page_loading', document.getElementById('page-loading').style.display);

      // hide all pages
      document.getElementById('page-cards').style.display = "none";
      document.getElementById('page-search').style.display = "none";
      document.getElementById('page-detail').style.display = "none";
      document.getElementById('page-loading').style.display = "none";

      // show bookmark page
      document.getElementById('page-bookmark').style.display = "block";
      this.bookmarkButtonClicked = true;
    }

  }

  render() {
    return (
      <div className="App">
        {/* ************************ Navigation Bar ************************* */}

        {this.isMobile ?
          // mobile navbar
          <Navbar bg="primary" variant="dark" style={{ background: 'linear-gradient(90deg, rgba(20,41,75,1) 0%, rgba(50,77,132,1) 50%, rgba(76,108,183,1) 100%)' }}>
            <Accordion>
              <Row>
                <Col>
                  <Search
                    onSearchChange={_.debounce(this.handleSearchChange, 1000, {
                      leading: true
                    })}
                    results={this.state.results}
                    onResultSelect={this.handleResultSelect}
                    placeholder={'Enter Keyword'}
                  />
                </Col>
                <Col>
                  <Accordion.Toggle as={Button} variant="outline-link" eventKey="0" className="test">
                    <NavItem>
                      <MdMenu></MdMenu>
                    </NavItem>
                  </Accordion.Toggle>
                </Col>
              </Row>

              <Accordion.Collapse eventKey="0">
                <Nav id='navbar-switch' defaultActiveKey="/home">
                  <ul style={{ listStyleType: 'none' }}>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="home" href="/home"> Home </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="world" href="/section/world"> World </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="politics" href="/section/politics"> Politics </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="business" href="/section/business"> Business </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="technology" href="/section/technology"> Technology </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link eventKey="sports" href="/section/sports"> Sports </Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item id='navbar-bookmark'>
                        <Button variant='link' onClick={this.handleBookMarkClicked}>
                          <MdBookmarkBorder></MdBookmarkBorder>
                        </Button>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link>NYTimes</Nav.Link>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Switch uncheckedIcon={false} checkedIcon={false} onChange={this.handleSwitchChange} checked={this.state.checked}></Switch>
                      </Nav.Item>
                    </li>
                    <li style={{ textAlign: 'left' }}>
                      <Nav.Item>
                        <Nav.Link>Guardian</Nav.Link>
                      </Nav.Item>
                    </li>
                  </ul>
                </Nav>
              </Accordion.Collapse>
            </Accordion>
          </Navbar>
          :
          // window view
          <Navbar bg="primary" variant="dark" style={{ background: 'linear-gradient(90deg, rgba(20,41,75,1) 0%, rgba(50,77,132,1) 50%, rgba(76,108,183,1) 100%)' }}>
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

            <Nav className="ml-auto" id='navbar-switch'>
              <Nav.Item id='navbar-bookmark'>
                <Button variant='link' onClick={this.handleBookMarkClicked}>
                  <MdBookmarkBorder></MdBookmarkBorder>
                </Button>
              </Nav.Item>
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
        }


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
                        document.getElementById('page-loading').style.display = "none";
                        document.getElementById('navbar-switch').style.display = "none";
                        document.getElementById('page-detail').style.display = "block";
                      }));
                    // show loading page
                    document.getElementById('page-cards').style.display = "none";
                    document.getElementById('page-loading').style.display = "block";
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
                            <MdShare></MdShare>
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
                                        news.sectionId === 'sport' ? { background: '#F6C245', color: 'black' } :
                                          { background: '#6E757C', color: 'white' }) :
                                /* nytimes */
                                (news.section === 'world' ? { background: '#7C4EFF', color: 'white' } :
                                  news.section === 'politics' ? { background: '#419488', color: 'white' } :
                                    news.section === 'business' ? { background: '#4696EC', color: 'white' } :
                                      news.section === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                        news.section === 'sports' ? { background: '#F6C245', color: 'black' } :
                                          { background: '#6E757C', color: 'white' }))}
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
          <h1>Results</h1>
          <CardColumns>
            {this.state.searches.map((news, index) =>
              <Card key={index} border="secondary" className="card card-thin">
                <a href={news &&
                  (this.state.checked ?
                    news.webUrl : /* guardian */
                    news.web_url /* nytimes */)}
                  className="card-link"
                  onClick={(event) => {
                    event.preventDefault();
                    if (this.shareButtonClicked) {

                    } else {
                      // link clicked

                      // fetch for details
                      fetch('home/detail', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                          source: this.state.checked ? 'guardian' : 'nytimes',
                          url:
                            (this.state.checked ?
                              this.state.searches[index].id /* guardian */ :
                              this.state.searches[index].web_url /* nytimes */)
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
                          document.getElementById('page-loading').style.display = "none";
                          document.getElementById('navbar-switch').style.display = "none";
                          document.getElementById('page-detail').style.display = "block";
                        }));
                      // show loading page
                      document.getElementById('page-search').style.display = "none";
                      document.getElementById('page-loading').style.display = "block";
                    }
                  }}>
                  <Container>
                    <Row>
                      <Col>
                        <Card.Title>
                          {news &&
                            (this.state.checked ?
                              news.webTitle : /* guardian */
                              news.headline.main/* nytimes */)}
                          <Button variant="link" key={index} onClick={(event) => {
                            event.preventDefault();
                            this.setState({
                              modal: {
                                show: true,
                                news: {
                                  title: news &&
                                    (this.state.checked ?
                                      news.webTitle : /* guardian */
                                      news.headline.main /* nytimes */),
                                  url: news &&
                                    (this.state.checked ?
                                      news.webUrl : /* guardian */
                                      news.web_url /* nytimes */)
                                }
                              }
                            }, () => {

                            });
                            this.shareButtonClicked = true;
                          }}>
                            <MdShare></MdShare>
                          </Button>
                        </Card.Title>
                      </Col>
                    </Row>
                    <Row>
                      <Card.Text></Card.Text>
                      <Card.Img src={
                        (this.state.checked ?
                          (news.blocks && news.blocks.main.elements[0].assets && (news.blocks.main.elements[0].assets[0] ?
                            news.blocks.main.elements[0].assets[0].file :
                            'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png')) : /* guardian */
                          (news.multimedia && (news.multimedia[0] ?
                            'http://static01.nyt.com/' + news.multimedia[0].url :
                            'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg' /* nytimes */)))}></Card.Img>
                    </Row>
                    <Container>
                      <Row>
                        <Col>
                          <Card.Text>
                            {news &&
                              (this.state.checked ?
                                (news.webPublicationDate && news.webPublicationDate.substring(0, 10)) : /* guardian */
                                (news.pub_date && news.pub_date.substring(0, 10)) /* nytimes */)}
                          </Card.Text>
                        </Col>
                        <Col>
                          <Button variant='outline-light' style={news && (this.state.checked ?
                            /* guardian */
                            (news.sectionId === 'world' ? { background: '#7C4EFF', color: 'white' } :
                              news.sectionId === 'politics' ? { background: '#419488', color: 'white' } :
                                news.sectionId === 'business' ? { background: '#4696EC', color: 'white' } :
                                  news.sectionId === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                    news.sectionId === 'sport' ? { background: '#F6C245', color: 'black' } :
                                      { background: '#6E757C', color: 'white' }) :
                            /* nytimes */
                            (news.news_desk === 'world' ? { background: '#7C4EFF', color: 'white' } :
                              news.news_desk === 'politics' ? { background: '#419488', color: 'white' } :
                                news.news_desk === 'business' ? { background: '#4696EC', color: 'white' } :
                                  news.news_desk === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                    news.news_desk === 'sports' ? { background: '#F6C245', color: 'black' } :
                                      { background: '#6E757C', color: 'white' }))}
                            size="sm" className='news-tag'>
                            {news &&
                              (this.state.checked ?
                                news.sectionId && news.sectionId.toUpperCase() :  /* guardian */
                                news.news_desk && news.news_desk.toUpperCase() /* nytimes */)}
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

        {/* *************** Bookmark Page *************** */}
        <div id="page-bookmark" className="page-bookmark">
          <h1>Favorite</h1>
          <CardColumns>
            {localStorage.getItem('news_bookmark_list') && JSON.parse(localStorage.getItem('news_bookmark_list')).map((news, index) =>
              <Card key={index} id={'bookmark' + index} border="secondary" className="card card-thin">
                <a href={news.url} className="card-link" onClick={(event) => {
                  event.preventDefault();
                  if (this.shareButtonClicked) {
                    // button clicked
                    return;
                  }
                  if (this.deleteButtonClicked) {
                    // button clicked
                    return;
                  }

                  // fetch for details
                  fetch('/home/detail', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                      source: news.source,
                      url: news.url
                    })
                  })
                    .then(res => res.json())
                    .then(res => this.setState({
                      news_detail:
                        (news.source === 'guardian' ?
                          res.response.content /* guardian */ :
                          res.response.docs[0] /* nytimes */)
                    }, () => {
                      // show results after fetching
                      document.getElementById('page-loading').style.display = "none";
                      document.getElementById('navbar-switch').style.display = "none";
                      document.getElementById('page-detail').style.display = "block";
                    }));
                  // show loading page
                  document.getElementById('page-bookmark').style.display = "none";
                  document.getElementById('page-loading').style.display = "block";
                }}>
                  <Container>
                    <Row>
                      <Col>
                        <Card.Title>
                          {news.title}
                          <Button variant="link" onClick={(event) => {
                            event.preventDefault();
                            this.setState({
                              modal: {
                                show: true,
                                news: {
                                  title: news.title,
                                  url: news.url
                                }
                              }
                            }, () => {

                            });
                            this.shareButtonClicked = true;
                          }}>
                            <MdShare></MdShare>
                          </Button>
                          <Button variant='link' key={index} onClick={(event) => {
                            event.preventDefault();

                            // get bookmark list
                            var news_bookmark_list = JSON.parse(localStorage.getItem('news_bookmark_list'));

                            // show toast
                            this.setState({
                              toast: {
                                show: true,
                                content: "Removing" + news_bookmark_list[index].title
                              }
                            });

                            // delete the item by index
                            news_bookmark_list.splice(index, 1);

                            // save list
                            localStorage.setItem('news_bookmark_list', JSON.stringify(news_bookmark_list));

                            // hide card
                            document.getElementById('bookmark' + index).style.display = "none";

                            this.deleteButtonClicked = true;
                          }}>
                            <MdDelete></MdDelete>
                          </Button>
                        </Card.Title>
                      </Col>
                    </Row>
                    <Row>
                      <Card.Text></Card.Text>
                      <Card.Img src={news.image}></Card.Img>
                    </Row>
                    <Container>
                      <Row>
                        <Col>
                          <Card.Text> {news.date && news.date.substring(0, 10)} </Card.Text>
                        </Col>
                        <Col>
                          <Button variant="outline-light" style={
                            news.source === 'guardian' ? { background: '#14284A', color: 'white' } :
                              { background: '#DDDDDD', color: 'black' }
                          } size='sm'>
                            {news.source && news.source.toUpperCase()}
                          </Button>
                          <Button variant='outline-light' style={
                            news.section === 'world' ? { background: '#7C4EFF', color: 'white' } :
                              news.section === 'politics' ? { background: '#419488', color: 'white' } :
                                news.section === 'business' ? { background: '#4696EC', color: 'white' } :
                                  news.section === 'technology' ? { background: '#CEDC39', color: 'black' } :
                                    news.section === 'sport' ? { background: '#F6C245', color: 'black' } :
                                      { background: '#6E757C', color: 'white' }}
                            size="sm">
                            {news.section && news.section.toUpperCase()}
                          </Button>
                        </Col>
                      </Row>
                    </Container>
                  </Container>
                </a>
              </Card>
            )}
          </CardColumns>

          {/* Toast */}
          <Toast show={this.state.toast.show} delay={1500} onClose={() => {
            this.setState({
              toast: {
                show: false,
                content: null
              }
            });
          }} style={{ position: 'absolute', top: '5%', left: '50%', transform: 'translate(-50%, 0px)' }} autohide>
            <Toast.Header>
              {this.state.toast.content}
            </Toast.Header>
          </Toast>
        </div>

        {/* *************** Detail Page *************** */}
        <div id="page-detail" className="page-detail">
          <Card className="text-left card">
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
                <Col style={{ textAlign: 'right' }}>
                  <OverlayTrigger placement='top' overlay={<Tooltip> Facebook </Tooltip>}>
                    <FacebookShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} hashtag={'#CSCI_571_NewsApp'}>
                      <FacebookIcon size={20} round></FacebookIcon>
                    </FacebookShareButton>
                  </OverlayTrigger>
                  <OverlayTrigger placement='top' overlay={<Tooltip> Twitter </Tooltip>}>
                    <TwitterShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} hashtag={'#CSCI_571_NewsApp'}>
                      <TwitterIcon size={20} round></TwitterIcon>
                    </TwitterShareButton>
                  </OverlayTrigger>
                  <OverlayTrigger placement='top' overlay={<Tooltip> Email </Tooltip>}>
                    <EmailShareButton url={this.state.news_detail && (this.state.checked ? this.state.news_detail.webUrl /* guardian */ : this.state.news_detail.web_url /* nytimes */)} subject={'#CSCI_571_NewsApp'}>
                      <EmailIcon size={20} round></EmailIcon>
                    </EmailShareButton>
                  </OverlayTrigger>
                </Col>
                <Col>
                  <OverlayTrigger placement='top' overlay={<Tooltip> Bookmark </Tooltip>}>
                    <Button variant='link' onClick={() => {

                      // show toast
                      this.setState({
                        toast: {
                          show: true,
                          content: "Saving" + this.state.news_detail &&
                            (this.state.checked ?
                              this.state.news_detail.webTitle : /* guardian */
                              this.state.news_detail.headline.main /* nytimes */)
                        }
                      });

                      // get current news
                      var news_bookmark = {
                        title: this.state.news_detail &&
                          (this.state.checked ?
                            this.state.news_detail.webTitle : /* guardian */
                            this.state.news_detail.headline.main /* nytimes */),
                        image: this.state.news_detail &&
                          (this.state.checked ?
                            (this.state.news_detail.blocks && this.state.news_detail.blocks.main.elements[0].assets && (this.state.news_detail.blocks.main.elements[0].assets[0] ?
                              this.state.news_detail.blocks.main.elements[0].assets[0].file :
                              'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png')) : /* guardian */
                            (this.state.news_detail.multimedia && (this.state.news_detail.multimedia[0] ?
                              'http://static01.nyt.com/' + this.state.news_detail.multimedia[0].url :
                              'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg' /* nytimes */))),
                        date: this.state.news_detail &&
                          (this.state.checked ?
                            this.state.news_detail.webPublicationDate : /* guardian */
                            this.state.news_detail.pub_date /* nytimes */),
                        source: this.state.checked ? 'guardian' : 'nytimes',
                        section: this.state.news_detail &&
                          (this.state.checked ?
                            this.state.news_detail.sectionId : /* guardian */
                            this.state.news_detail.section_name /* nytimes */),
                        url: this.state.news_detail &&
                          (this.state.checked ?
                            this.state.news_detail.id : /* guardian */
                            this.state.news_detail.web_url /* nytimes */)
                      };

                      // get bookmark list
                      var news_bookmark_list = JSON.parse(localStorage.getItem('news_bookmark_list'));

                      if (news_bookmark_list) {
                        // news_bookmark_list exists

                        // filter out the existed bookmark
                        var i = 0;
                        for (; i < news_bookmark_list.length; i++) {
                          if (news_bookmark_list[i].url === news_bookmark.url) {
                            break;
                          }
                        }

                        if (i < news_bookmark_list.length) {
                          // the bookmark is already existed
                        } else {
                          // the bookmark is not existed
                          news_bookmark_list.push(news_bookmark);
                        }
                      } else {
                        news_bookmark_list = [];
                        news_bookmark_list.push(news_bookmark);
                      }

                      // push bookmark list
                      console.log(localStorage.getItem('news_bookmark_list'));
                      localStorage.setItem('news_bookmark_list', JSON.stringify(news_bookmark_list));

                    }}>
                      <MdBookmarkBorder></MdBookmarkBorder>
                    </Button>
                  </OverlayTrigger>
                </Col>
              </Row>
              <Row className="card-row">
                <Card.Img src={this.state.news_detail &&
                  (this.state.checked ?
                    (this.state.news_detail.blocks && this.state.news_detail.blocks.main.elements[0].assets && (this.state.news_detail.blocks.main.elements[0].assets[0] ?
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
                        this.state.news_detail.blocks && this.state.news_detail.blocks.body[0].bodyTextSummary : /* guardian */
                        this.state.news_detail.abstract /* nytimes */)}
                  </Card.Text>
                </Col>
              </Row>
            </Container>
          </Card>

          {/* Toast */}
          <Toast show={this.state.toast.show} delay={1500} onClose={() => {
            this.setState({
              toast: {
                show: false,
                content: null
              }
            });
          }} style={{ position: 'absolute', top: '5%', left: '50%', transform: 'translate(-50%, 0px)' }} autohide>
            <Toast.Header>
              {this.state.toast.content}
            </Toast.Header>
          </Toast>

          {/* Commentbox */}
          <div>
            <div className="commentbox" id={this.state.news_detail && (this.state.checked ? this.state.news_detail.id : this.state.news_detail.web_url)}> </div>
          </div>
        </div>
      </div>
    );
  };
}

export default App;
