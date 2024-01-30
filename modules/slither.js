const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function runSlither(solidityFilePath) {
    try {
        console.log(`Running Slither on ${solidityFilePath}`);

        // Install and use specific Solidity compiler version
        console.log('Installing Solidity compiler version 0.7.6...');
        await exec('solc-select install 0.7.6');
        console.log('Using Solidity compiler version 0.7.6...');
        await exec('solc-select use 0.7.6');

        // Run Slither
        const { stdout } = await exec(`slither ${solidityFilePath}`);
        console.log(`Slither Analysis Output:\n${stdout}`);
    } catch (err) {
        console.error(`Error: ${err.message}`);
    }
}

// Adjust this to the path of your Solidity file
const solidityFilePath = 'samples/TimeLock.sol';
runSlither(solidityFilePath);
