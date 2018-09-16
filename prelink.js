#!/usr/bin/env node
const Path = require("path");
const fs = require("fs");
const plist = require("plist");
const glob = require("glob");
const package = require(Path.join(process.cwd(), "package.json"));
const { peerDependencies, startupClasses } = package;
const newStartupClasses = [];
if (peerDependences && typeof peerDependencies === "object") {
  Object.keys(peerDependencies).forEach(node_module => {
    try {
      const { startupClasses } = require(require.resolve(
        Path.join(node_module, "package.json")
      ));
      if (startupClasses) {
        newStartupClasses = newStartupClasses.concat(startupClasses);
      }
    } catch (e) {}
  });
  //OK let's load up our plist now
  const pglobs = glob.sync(Path.join("ios", "*", "info.plist"));
  if (!pglobs) {
    console.log("Could not find the plist file");
    return;
  }
  const pglob = pglobs.shift();
  const txt = fs.readFileSync(pglob, { encoding: "UTF8" });
  const o = plist.parse(txt);
  o.RNSRClasses = newStartupClasses.filter(v => v);
  fs.writeFileSync(pglob, plist.build(o));
}
