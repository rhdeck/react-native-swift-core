#!/usr/bin/env node
var { existsSync } = require("fs");
var { join } = require("path");
//Get my directory
const { dependencies, devDependencies } = require(join(
  process.cwd(),
  "package.json"
));
//scan for swift icons
const allDependencies = Object.keys({ ...dependencies, ...devDependencies });
allDependencies.forEach(dependency => {
  const base = require.resolve.paths(dependency).find(path => {
    const joined = join(path, dependency, "react-native-swift.config.js");
    return existsSync(joined);
  });
  if (!base) return;
  const rnsc = join(base, dependency, "react-native-swift.config.js");
  if (!rnsc) return;
  const { prelink } = require(rnsc);
  if (prelink)
    if (Array.isArray(prelink)) prelink.forEach(p => p());
    else prelink();
});
allDependencies.forEach(dependency => {
  const base = require.resolve.paths(dependency).find(path => {
    const joined = join(path, dependency, "react-native-swift.config.js");
    return existsSync(joined);
  });
  if (!base) return;
  const rnsc = join(base, dependency, "react-native-swift.config.js");
  if (!rnsc) return;
  const { postlink } = require(rnsc);
  if (postlink)
    if (Array.isArray(postlink)) postlink.forEach(p => p());
    else postlink();
});
