#!/usr/bin/env node
var { readFileSync, writeFileSync, existsSync } = require("fs");
var { join } = require("path");
var glob = require("glob");
const plist = require("plist");

//Get my directory
const { dependencies, devDependencies } = require(join(
  process.cwd(),
  "package.json"
));
//scan for swift icons
const allDependencies = Object.keys({ ...dependencies, ...devDependencies });
const startupClasses = allDependencies
  .flatMap(dependency => {
    console.log("looking for rnscj in", dependency);
    const base = require.resolve.paths(dependency).find(path => {
      const joined = join(path, dependency, "react-native-swift.config.js");
      return existsSync(joined);
    });
    if (!base) return;
    const rnsc = join(base, dependency, "react-native-swift.config.js");
    console.log("Found a winner in", rnsc);
    const { startupClasses } = require(rnsc);
    console.log("startup classes are", startupClasses);
    return startupClasses;
  })
  .filter(Boolean);

const pglobs = glob.sync(join("ios", "*", "info.plist"));
if (!pglobs) {
  console.log("Could not find the plist file");
  return;
}
pglobs.forEach(pglob => {
  const txt = readFileSync(pglob, { encoding: "UTF8" });
  const o = plist.parse(txt);
  o.RNSRClasses = startupClasses;
  writeFileSync(pglob, plist.build(o));
});
console.log("Updated RNSR classes to", startupClasses.join(", "));
