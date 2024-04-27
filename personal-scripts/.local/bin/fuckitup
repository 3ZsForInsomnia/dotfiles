#!/usr/bin/env node

const prepArgs = (args) => {
    let [flag, ...textToFuckUp] = args;

    if (flag.charAt(0) !== '-') {
        textToFuckUp = flag;
        flag = '-f';
    } else if (flag.length > 2) {
        flag = flag.slice(0, 2);
        textToFuckUp = flag.slice(3);
    }

    return [flag, textToFuckUp];
};

const fuckItUp = (word) => word.split('')
    .map((letter, index) => index % 2 === 0 
        ? letter.toLowerCase() 
        : letter.toUpperCase()).join('');

const capitalize = (word) => word.charAt(0).toUpperCase() + word.slice(1);

const flagsToFuckerUppers = {
    '-f': fuckItUp,
    '-c': capitalize,
};

const [flag, textToFuckUp] = prepArgs(process.argv.slice(2));

let fuckerUpper = flagsToFuckerUppers[flag];
const result = textToFuckUp.map(fuckerUpper).join(' ');
console.log(result);
