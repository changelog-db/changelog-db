import yaml from "js-yaml";
import * as fs from "node:fs";

async function get(pkg) {
  const data = await new Promise((resolve, reject) => {
    fs.readFile("changelog-db.yaml", {}, (err, data) => {
      if (err) {
        reject(err);
      } else {
        resolve(data);
      }
    });
  });
  const value = yaml.load(data)[pkg];
  if (value) {
    console.log(value);
  } else if (value === false) {
    console.log(`${pkg} has no changelog`);
  } else {
    console.log(`${pkg} isn't in the database`);
  }
}

get(process.argv[2]);
