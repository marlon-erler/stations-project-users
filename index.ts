#! /usr/bin/env node

//IMPORTS
import Fs from "fs/promises";

//MAIN
let dir = "Users";
let subcommand = process.argv[2];

//repair
if (subcommand == "init") {
	Fs.mkdir(dir);
	process.exit();
}

//main
process.chdir(dir);
switch (subcommand) {
	case "ls": {
		let contents = await Fs.readdir(".");
		console.log(contents.join("\n"));
		break;
	}
	default: {
		console.log("e3");
	}
}
