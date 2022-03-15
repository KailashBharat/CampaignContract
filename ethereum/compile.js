const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath); //Delete the build directory and everything in it

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
const source = fs.readFileSync(campaignPath, "utf-8");

const input = {
  language: "Solidity",
  sources: {
    "Campaign.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "Campaign.sol"
];

fs.ensureDirSync(buildPath); //Ensure that the build directory exists

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract + ".json"),
    output[contract]
  );
}

module.exports = output;
