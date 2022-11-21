#! /usr/bin/env node

let subcommand = process.argv.splice(0, 1)[0];

switch (subcommand) {
	default: {
		process.stdout.write("e3");
	}
}
