import React from "react";

export default class Root extends React.Component {
  state = {
    hasError: false
  };

  componentDidCatch(error, info) {
    this.setState({ hasError: true });
  }

  render() {
    if (this.state.hasError) {
      return <div className="error">Error</div>;
    } else {
      return (
        <>
          <a className="navbar-brand" href="/">
            <img
              src="https://single-spa.js.org/img/logo-white-bgblue.svg"
              className="d-inline-block align-top"
              height="30"
              width="30"
              alt=""
            />
            Microfrontends Demo
          </a>
          <div className="collapse navbar-collapse">
            <ul className="navbar-nav">
              <li className="nav-item">
                <a className="nav-link" href="/employees">
                  Employees
                </a>
              </li>
            </ul>
          </div>
          <em className="text-white">Navbar - React/JavaScript</em>
        </>
      );
    }
  }
}
