const base = '/sap/zabapopenfix';
const Link = ReactRouter.Link;

function handleError(evt, callback, json) {
  if (evt.target.status === 200) {
    if (json === true) {
      callback(JSON.parse(evt.target.responseText).DATA);
    } else {
      callback(evt.target.responseText);
    }
  } else {
    alert("REST call failed, status: " + evt.target.status);
  }
}

class REST {
  static root = base + "/rest/";

  static listWorklists(callback) {
    this.get("worklists", callback);
  }

  static listTasks(worklist, callback) {
    this.get("tasks/" + worklist, callback);
  }

  static get(folder, callback, json = true) {
    let oReq = new XMLHttpRequest();
    oReq.addEventListener("load", (evt) => { handleError(evt, callback, json); });
    oReq.open("GET", this.root + folder);
    oReq.send();
  }
}

class NoMatch extends React.Component {
  render() {
    return (<h1>router, no match</h1>);
  }
}

class TaskList extends React.Component {
  constructor() {
    super();
  }     
      
  render() {
    return (
      <div>
      <h1>Tasks</h1>
      foobar
      </div>);
  }
}

class WorklistList extends React.Component {
  constructor() {
    super();
    this.state = {data: [], spinner: true};
    REST.listWorklists(this.update.bind(this));
  }     

  update(d) {
    this.setState({data: d, spinner: false});
  }

  worklist(e) {
    return (
      <div>
      <Link to={"tasks/" + e.WORKLIST}>{e.DESCRIPTION}</Link><br />
      </div>);
  } 
      
  render() {
    return (
      <div>
      <h1>abapOpenFix</h1>
      {this.state.spinner?"loading":this.state.data.map(this.worklist)}
      <br />
      <br />
      <a href={base + "/rest/swagger.html"}>swagger</a>
      </div>);
  }
}

class Router extends React.Component {
        
  render() { 
    const history = ReactRouter.useRouterHistory(History.createHistory)({ basename: base });
      
    return (
      <ReactRouter.Router history={history} >
        <ReactRouter.Route path="/">
          <ReactRouter.IndexRoute component={WorklistList} />
          <ReactRouter.Route path="tasks/:worklist" component={TaskList} />
        </ReactRouter.Route>
        <ReactRouter.Route path="*" component={NoMatch} />
      </ReactRouter.Router>);
  }
}
      
ReactDOM.render(<Router />, document.getElementById('app'));