#!/usr/bin/env node
const Path = require("path");
const fs = require("fs");
const plist = require("plist");
const glob = require("glob");
const package = require(Path.join(process.cwd(), "package.json"));
const { dependencies } = package;
let newStartupClasses = [];
const findNodeModule = (node_module, cwd) => {
  if (!cwd) return;
  const p = Path.join(cwd, "node_modules", node_module, "package.json");
  if (fs.existsSync(p)) return p;
  else return findNodeModule(Path.dirname(p));
};
if (dependencies && typeof dependencies === "object") {
  Object.keys(dependencies).forEach(node_module => {
    try {
      const path = findNodeModule(node_module, process.cwd());
      const { startupClasses } = require(path);
      if (startupClasses) {
        newStartupClasses = newStartupClasses.concat(startupClasses);
      }
    } catch (e) {
      console.log("Error", e);
    }
  });

  //OK let's load up our plist now
  const pglobs = glob.sync(Path.join("ios", "*", "info.plist"));
  if (!pglobs) {
    console.log("Could not find the plist file");
    return;
  }
  pglobs.forEach(pglob => {
    const txt = fs.readFileSync(pglob, { encoding: "UTF8" });
    const o = plist.parse(txt);
    o.RNSRClasses = newStartupClasses.filter(v => v);
    fs.writeFileSync(pglob, plist.build(o));
  });
  console.log("Updated RNSR classes to", newStartupClasses.join(", "));
} else {
  console.log("No dependencies to work with");
}
