#!/usr/bin/env node
var { readFileSync } = require("fs");
var { join, dirname } = require("path");
var glob = require("glob");
const plist = require("plist");

//Get my directory
const { dependencies, devDependencies } = require(join(
  process.cwd(),
  "package.json"
));
//scan for swift icons
const baseDir = process.cwd();
const allDependencies = Object.keys({ ...dependencies, ...devDependencies });
const startupClasses = allDependencies
  .flatMap(dependency => {
    const packagePath = module.require(dependency);
    const packageDir = dirname(packagePath);
    const { ["react-native-swift"]: { startupClasses } = {} } = JSON.parse(
      readFileSync(packagePath, { encoding: "utf8" })
    );
    return startupClasses;
  })
  .filter(Boolean);

const pglobs = glob.sync(Path.join("ios", "*", "info.plist"));
if (!pglobs) {
  console.log("Could not find the plist file");
  return;
}
pglobs.forEach(pglob => {
  const txt = fs.readFileSync(pglob, { encoding: "UTF8" });
  const o = plist.parse(txt);
  o.RNSRClasses = startupClasses;
  fs.writeFileSync(pglob, plist.build(o));
});
console.log("Updated RNSR classes to", newStartupClasses.join(", "));
