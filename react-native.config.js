const fs = require("fs");
const path = require("path");
const inquirer = require("inquirer");
const hexrgb = require("hex-rgb");
const { spawnSync } = require("child_process");
module.exports = {
  commands: [
    {
      name: "swift-link",
      description: "Initialize react-native-swift related packages",
      func: () => {
        spawnSync("node", [path.join(__dirname, "bin", "set-swift-base.js")], {
          stdio: "inherit"
        });
        //Go looking for other dependencies and devDependencies on the project
        spawnSync("node", [path.join(__dirname, "bin", "swift-link.js")], {
          stdio: "inherit"
        });
      }
    },
    {
      name: "set-appdelegate",
      description: "Activate the stock appdelegate.swift",
      func: () => {
        spawnSync(
          "node",
          [path.join(__dirname, "bin", "set-swift-base.js")],

          {
            stdio: "inherit"
          }
        );
      }
    },
    {
      name: "set-classes",
      description: "Update plist with startup classes",
      func: () => {
        spawnSync(
          "node",
          [path.join(__dirname, "bin", "setstartupclasses.js")],
          {
            stdio: "inherit"
          }
        );
      }
    },
    {
      name: "bgcolor [newcolor]",
      description: "Set background color for application",
      func: newcolor => {
        if (newcolor && typeof newcolor !== "string") {
          newcolor = newcolor[0];
        }
        const pp = path.join(process.cwd(), "package.json");
        const p = require(pp);
        if (typeof newcolor !== "undefined") {
          p.backgroundColor = newcolor;
          fs.writeFileSync(pp, JSON.stringify(p, null, 2));
          require("./lib/setPListColor")();
          console.log("Saved and applied color", newcolor);
          return;
        }
        defColor = "";
        if (p.backgroundColor) {
          defColor = p.backgroundColor;
        }

        inquirer
          .prompt({
            name: "bgcolor",
            message:
              "What color do you want for your default background? (as Hex value)",
            default: defColor,
            validate: answer => {
              try {
                return hexrgb(answer) ? true : false;
              } catch (e) {
                return false;
              }
            }
          })
          .then(answers => {
            p.backgroundColor = answers.bgcolor;
            fs.writeFileSync(pp, JSON.stringify(p, null, 2));
            require("./lib/setPListColor")();
            console.log("Updated background color", answers.bgcolor);
          });
      }
    }
  ]
};
