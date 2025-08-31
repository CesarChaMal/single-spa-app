import React from "react";

export interface Employee {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  avatar: string;
}

interface ComponentState {
  employees: Employee[];
}

export default class Root extends React.Component<any, ComponentState> {
  constructor(props: ComponentState) {
    super(props);

    this.state = { employees: [] };
  }

  componentDidMount() {
    fetch("https://reqres.in/api/users")
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error('API request failed');
      })
      .then((data) => {
        this.setState({ employees: data.data || [] });
      })
      .catch((error) => {
        console.error('Failed to fetch employees:', error);
        // Use mock data as fallback
        this.setState({ 
          employees: [
            { id: 1, first_name: "John", last_name: "Doe", email: "john@example.com", avatar: "" },
            { id: 2, first_name: "Jane", last_name: "Smith", email: "jane@example.com", avatar: "" },
            { id: 3, first_name: "Bob", last_name: "Johnson", email: "bob@example.com", avatar: "" }
          ]
        });
      });
  }

  componentDidCatch(error, errorInfo) {
    console.log(error);
  }

  render() {
    const { employees } = this.state;

    if (!employees || !employees.length) {
      return (
        <div className="spinner-border" role="status">
          <span className="sr-only">Loading...</span>
        </div>
      );
    }

    return (
      <div>
        <table className="table table-striped table-bordered table-sm">
          <thead>
            <tr>
              <th scope="col">ID</th>
              <th scope="col">First Name</th>
              <th scope="col">Last Name</th>
              <th scope="col">Email</th>
            </tr>
          </thead>
          <tbody>
            {employees.map((employee: Employee) => {
              return (
                <tr key={employee.id}>
                  <th>
                    <a href={`/employees/${employee.id}`}>{employee.id}</a>
                  </th>
                  <td>{employee.first_name}</td>
                  <td>{employee.last_name}</td>
                  <td>{employee.email}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
        <em>Employees - React/TypeScript</em>
      </div>
    );
  }
}
