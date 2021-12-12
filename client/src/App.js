import React, { Component } from "react";
import Kontrak from "./contracts/Kontrak.json";
import getWeb3 from "./getWeb3";
import { Nav } from "react-bootstrap";
import { BrowserRouter as Switch, Route } from "react-router-dom";

import Home from "./components/Home";
import Login from "./components/Login";
import Register from "./components/Register";
import "./App.css";

class App extends Component {
  state = {
    web3: null,
    account: null,
    KontrakInstance: undefined,
    isOwner: false,
  };

  componentDidMount = async () => {
    const web3 = await getWeb3();

    const accounts = await web3.eth.getAccounts();

    const networkId = await web3.eth.net.getId();
    const deployedNetwork = Kontrak.networks[networkId];
    const instance = new web3.eth.Contract(
      Kontrak.abi,
      deployedNetwork && deployedNetwork.address
    );

    this.setState({
      KontrakInstance: instance,
      web3: web3,
      account: accounts[0],
    });

    const owner = await this.state.KontrakInstance.methods.superAdmin().call();
    if (this.state.account === owner) {
      this.setState({ isOwner: true });
    }
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div>
        
      </div>
    );
  }
}

export default App;
