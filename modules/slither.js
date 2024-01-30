const { exec } = require("child_process");
const path = require("path");

// Adjust this to the path of your Solidity file
const solidityFilePath = path.join(__dirname, './samples/your_solidity_file.sol');

exec(`slither ${solidityFilePath}`, (error, stdout, stderr) => {
    if (error) {
        console.error(`Error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.error(`Stderr: ${stderr}`);
        return;
    }
    console.log(`Slither Analysis Output:\n${stdout}`);
});