// ES Modules
import parse from 'html-react-parser';
// CommonJS
// const parse = require('html-react-parser');

export default function Root(props) {

  // var thisIsMyHome = '<div className="jumbotron">';
  // thisIsMyHome += '<h1 className="display-4">Hello, world!</h1>';
  // thisIsMyHome += '<p className="lead">This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>';
  // thisIsMyHome += '<hr className="my-4">';
  // thisIsMyHome += '<p>It uses utility classes for typography and spacing to space content out within the larger container.</p>';
  // thisIsMyHome += '<p className="lead">';
  // thisIsMyHome += '  <a className="btn btn-primary btn-lg" href="#" role="button">Learn more</a>';
  // thisIsMyHome += '</p>';
  // thisIsMyHome += '</div>';
  // thisIsMyHome += '<em>{{props.name}} using React</em>';

  const thisIsMyHome = `
  <div class="jumbotron">
    <h1 class="display-4">Hello, world!</h1>
    <p class="lead">
      This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.
    </p>
    <hr class="my-4">
    <p>
      It uses utility classes for typography and spacing to space content out within the larger container.
    </p>
    <p class="lead">
      <a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a>
    </p>
  </div>
  <em>${props.name} using React</em>
`;

  // return (
  //   <div className="content">{parse(thisIsMyHome)}</div>
  // );


  return (
    <div className="content">
      <div className="jumbotron">
        <h1 className="display-4">Hello, world!</h1>
        <p className="lead">
          This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.
        </p>
        <hr className="my-4" />
        <p>
          It uses utility classes for typography and spacing to space content out within the larger container.
        </p>
        <p className="lead">
          <a className="btn btn-primary btn-lg" href="#" role="button">Learn more</a>
        </p>
      </div>
      <em>{props.name} using React</em>
    </div>
  );

}
