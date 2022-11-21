#! /usr/bin/env node

//IMPORTS
import Bcrypt from "bcypt";
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

	case "add": {
		let dispname = process.argv[3];
		let pswd = process.argv[4];

		let station;
		//wait for number
		process.stdin.once("data", async data => {
			station = data.toString();
			let number = await generateNumber(station, dispname)
			let dirname = `a${number}`;

			try {
				Fs.mkdir(dirname);

				let password_hash = hash(pswd ?? "0000");
				console.log(password_hash);
			} catch {
				console.log("e2");
				process.exit();
			}

			process.exit(0);
		});
		//ask for number
		process.stdout.write("@info number");
		break;
	}

	default: {
		console.log("e3");
	}
}

function getT9Key(letter: string): string {
	switch (letter.toLowerCase()) {
		case "1": {
			return "1";
		} 
		case "2": case "a": case "b": case "c": {
			return "2";
		}
		case "3": case "d": case "e": case "f": {
			return "3";
		}
		case "4": case "g": case "h": case "i": {
			return "4";
		}
		case "5": case "j": case "k": case "l": {
			return "5";
		}
		case "6": case "m": case "n": case "o": {
			return "6";
		}
		case "7": case "p": case "q": case "r": case "s": {
			return "7";
		}
		case "8": case "t": case "u": case "v": {
			return "8";
		}
		case "9": case "w": case "x": case "y": case "z": {
			return "9";
		}
		default: {
			return "0";
		}
	}
}

async function generateNumber(station: string, username: string): Promise<string> {
	//get first four letters or numbers
	let number = station + "0";
	let letters = username
		.padEnd(4, "1")
		.split("")
		.filter(x => /[0-9a-zA-Z]/.test(x) == true)
		.splice(0, 4);
	;

	//convert to number 
	let i = 0;
	while (i < 4) {
		if (i < letters.length) number += getT9Key(letters[i]);
		else number += "1";

		i++;
	}

	//get existing numbers
	let usernames = await Fs.readdir(".");
	let matches = usernames
		.filter(async (x: string)  => (await Fs.stat(x)).isDirectory() == true)
		.filter(x => x.includes(number))
	;
	let match_count;

	//test number for availability
	let j = 0;
	let run = true;
	while (run == true) {
		let test_count = j.toString().padStart(4, "0");
		let dirname = "a" + number + test_count;
		if (matches.includes(dirname)) {
			j++;
		} else {
			run = false;
			match_count = test_count;
		}
	}

	number += match_count;
	return number;
}

function hash(string: string): string {
	return Crypto.createHash("argon2").update(string).digest("hex");
}
