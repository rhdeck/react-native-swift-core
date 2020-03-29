#!/usr/bin/env node
var pbxproj = require("@raydeck/xcode");
var { readFileSync } = require("fs");
var { join, dirname } = require("path");
var glob = require("glob");
//Get my directory
const { dependencies, devDependencies } = require(join(
  process.cwd(),
  "package.json"
));
//scan for swift icons
const baseDir = process.cwd();
const allDependencies = Object.keys({ ...dependencies, ...devDependencies })(
  allDependencies
).forEach(dependency => {
  const packagePath = module.require(dependency);
  const packageDir = dirname(packagePath);
  const { swiftcommands } = JSON.parse(
    readFileSync(packagePath, { encoding: "utf8" })
  );
  const rnslPath = join(packageDir, "react-native-swift.config.js");
  const { prelink } = require(rnslPath);
  if (Array.isArray(prelink)) prelink.forEach(p => p());
  else prelink();
});
allDependencies.forEach(dependency => {
  const packagePath = module.require(dependency);
  const packageDir = dirname(packagePath);
  const { swiftcommands } = JSON.parse(
    readFileSync(packagePath, { encoding: "utf8" })
  );
  const rnslPath = join(packageDir, "react-native-swift.config.js");
  const { postlink } = require(rnslPath);
  if (Array.isArray(postlink)) postlink.forEach(p => p());
  else prelink();
});
