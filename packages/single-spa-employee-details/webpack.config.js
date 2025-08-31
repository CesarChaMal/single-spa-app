const singleSpaAngularWebpack = require('single-spa-angular/lib/webpack').default;

module.exports = (config, options) => {
  const singleSpaWebpackConfig = singleSpaAngularWebpack(config, options);
  
  // Ensure SystemJS format
  singleSpaWebpackConfig.output.libraryTarget = 'system';
  
  // Set the correct public path
  singleSpaWebpackConfig.output.publicPath = 'http://localhost:4200/';
  
  return singleSpaWebpackConfig;
};