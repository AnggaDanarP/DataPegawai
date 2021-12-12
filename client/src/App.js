import React, { Component } from "react";
import Kontrak from "./contracts/Kontrak.json";
import getWeb3 from "./getWeb3";
import { Link } from "react-router-dom";

import { Navbar, Container, Nav } from "react-bootstrap";

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
      <Navbar bg="dark" variant="dark">
        <Container>
          <Link to="./components/Home.js">
            <img
              alt=""
              src="/logo.svg"
              width="30"
              height="30"
              className="d-inline-block align-top"
            />{" "}
            PT ROMBONG TAHTA MANDIRI
          </Link>
          <Nav.Link href="./components/Login">Login</Nav.Link>
          <Nav.Link href="./components/Register">Register</Nav.Link>
        </Container>
      </Navbar>
    );
  }
}

export default App;
