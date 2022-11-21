#! /usr/bin/env node

process.stdin.setEncoding("utf8");
process.stdin.on("data", data => {
	console.log(data);
});
console.log("@exec ls");
