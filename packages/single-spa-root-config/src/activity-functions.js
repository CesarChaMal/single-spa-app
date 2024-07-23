export function navbar(location) {
  console.log(location)
  console.log(location.pathname)
  return true; // The navbar is always active
}

export function employees(location) {
  console.log(location)
  console.log(location.pathname)
  return location.pathname === "/employees";
  // return true;
}

export function employeeDetails(location) {
  console.log(location)
  console.log(location.pathname)
  const regex = /^\/employees\/\d+?$/;
  return location.pathname.match(regex);
}

export function home(location) {
  console.log(location)
  console.log(location.pathname)
  return true; // The home always active
}