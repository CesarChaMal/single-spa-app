import { registerApplication, start } from "single-spa";
import * as isActive from "./activity-functions";

registerApplication(
  "single-spa-navbar",
  () => System.import("single-spa-navbar"),
  isActive.navbar
);

registerApplication({
  name: "single-spa-employees",
  app: () => System.import("single-spa-employees"),
  activeWhen: isActive.employees
});

registerApplication({
  name: "single-spa-employee-details",
  app: () => System.import("single-spa-employee-details"),
  activeWhen: isActive.employeeDetails
});

registerApplication({
  name: "single-spa-home",
  app: () => System.import("single-spa-home"),
  activeWhen: location => location.pathname === "/"
  //activeWhen: isActive.home
});

start();
