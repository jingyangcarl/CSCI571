import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
// import Customers from './Components/customers/customers';
import Home from './Components/home/home';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Home></Home>
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
        {/* <Customers></Customers> */}
      </div>
    );
  };
}

export default App;
