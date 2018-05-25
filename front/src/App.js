import React, {Component} from 'react';
import axios from 'axios';
import moment from 'moment'
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.js';

class App extends Component {
  state = {
    apiDomain: 'http://localhost:3000/v1/domains/',
    key: 'istosElid@s!',
    session: '',
    domainError: '',
    activeDomain: '',
    domain: '',
    domains: []
  };

  componentDidMount() {
    // this.fetchDomain()
  }

  fetchDomain = () => {
    axios.get(`${this.state.apiDomain}?key=${this.state.key}`)
      .then(res => {
        const domains = res.data;
        this.setState({domains: domains});
      })
  };

  parseDomain = (domainId) => {
    axios.get(`${this.state.apiDomain}${domainId}/parse?key=${this.state.key}`)
      .then(() => {
        this.fetchDomain();
      })
  };

  deleteDomain = (domainId) => {
    axios.delete(`${this.state.apiDomain}${domainId}?key=${this.state.key}`)
      .then(() => {
        this.fetchDomain();
      })
  };

  handleKeyPress = (event) => {
    if (event.key === 'Enter') {
      axios.post(`${this.state.apiDomain}?key=${this.state.key}`, {
        url: this.state.domain
      })
        .then(res => {
          if (res.data.message === 'error') {
            this.setState({domainError: 'Invalid domain.'})
          } else {
            this.setState({domain: '', domainError: ''});
            this.fetchDomain();
          }
        })
    }
  };

  showDomain = (domainId) => {
    axios.get(`${this.state.apiDomain}${domainId}?key=${this.state.key}`)
      .then(res => {
        const activeDomain = res.data.data;
        if (activeDomain) {
          this.setState({activeDomain});
        }
      })
  };

  handleChange = (event) => {
    this.setState({domain: event.target.value});
  };

  handleKey = (event) => {
    this.setState({key: event.target.value});
  };

  render() {
    return (
      <div className="App container">
        <header className="App-header">
          <h1 className="App-title">
            Domain parser

            <button onClick={this.fetchDomain} disabled={!this.state.key} className="btn btn-success">Fetch
              Domains
            </button>
          </h1>
        </header>
        <div className="form-group">
          <input value={this.state.key} className="form-control" onChange={this.handleKey} placeholder="Key"/>
          <br/>
          <input className="domain-input form-control" disabled={!this.state.key}
                 placeholder="Add domain to parse and press enter" value={this.state.domain}
                 onChange={this.handleChange} onKeyPress={this.handleKeyPress}/>
        </div>
        {this.state.domainError
          ? <div className="alert alert-danger" role="alert">{this.state.domainError}</div>
          : ''}
        <div className="column domain-scroll">
          <table className="domains-list table">
            <thead>
            <tr>
              <th>Domain</th>
              <th>Last parsed</th>
              <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            {this.state.domains.map(domain => <tr key={domain.id} className="domain-list"
                                                  onClick={() => this.showDomain(domain.id)}>
              <td>{domain.url}</td>
              <td>{moment(domain.parsed_at).format('LLLL')}</td>
              <td className="actions">
                <button onClick={() => this.parseDomain(domain.id)} className="btn btn-success">Parse again</button>
                <button onClick={() => this.deleteDomain(domain.id)} className="btn btn-danger">Delete</button>
              </td>
            </tr>)}
            </tbody>
          </table>
        </div>
        <ul className="nav nav-tabs" role="tablist">
          <li className="nav-item">
            <a className="nav-link active" id="domain-info-tab" data-toggle="tab" href="#domain-info" role="tab"
               aria-controls="domain-info"
               aria-selected="true">Social Media</a>
          </li>
          <li className="nav-item">
            <a className="nav-link" id="headers-tab" data-toggle="tab" href="#headers" role="tab"
               aria-controls="headers" aria-selected="false">Headers</a>
          </li>
          <li className="nav-item">
            <a className="nav-link" id="strong-tab" data-toggle="tab" href="#strong" role="tab"
               aria-controls="strong" aria-selected="false">Strong / Bold</a>
          </li>
          <li className="nav-item">
            <a className="nav-link" id="metadata-tab" data-toggle="tab" href="#metadata" role="tab"
               aria-controls="metadata" aria-selected="false">Metadata</a>
          </li>
        </ul>
        <div className="tab-content" id="myTabContent">
          <div className="tab-pane fade show active" id="domain-info" role="tabpanel" aria-labelledby="domain-info-tab">
            <div><b>URL:</b> {this.state.activeDomain && this.state.activeDomain.attributes.url}</div>
            <div><b>Facebook:</b> {this.state.activeDomain && this.state.activeDomain.attributes.facebook}</div>
            <div><b>Instagram:</b> {this.state.activeDomain && this.state.activeDomain.attributes.instagram}</div>
            <div><b>Twitter:</b> {this.state.activeDomain && this.state.activeDomain.attributes.twitter}</div>
            <div><b>Youtube:</b> {this.state.activeDomain && this.state.activeDomain.attributes.youtube}</div>
          </div>
          <div className="tab-pane fade" id="headers" role="tabpanel" aria-labelledby="headers-tab">
            {this.state.activeDomain && this.state.activeDomain.attributes.headers.map(header => <li
              key={header.id}>{header.header_type} {header.phrase}</li>)}
          </div>
          <div className="tab-pane fade" id="strong" role="tabpanel" aria-labelledby="strong-tab">
            {this.state.activeDomain && this.state.activeDomain.attributes.strongs.map(strong => <li
              key={strong.id}>{strong.phrase}</li>)}
          </div>
          <div className="tab-pane fade" id="metadata" role="tabpanel" aria-labelledby="metadata-tab">
            {this.state.activeDomain && this.state.activeDomain.attributes.metadatas.map(metadata => <li
              key={metadata.id}>{metadata.metadata}</li>)}
          </div>
        </div>
        <br/>
        <br/>
      </div>
    );
  }
}

export default App;
