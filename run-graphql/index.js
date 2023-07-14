import { program } from 'commander';
import { setup } from './setup.js';
import * as actions from './actions/index.js';
import fs from 'fs-extra';
import * as path from 'path';
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function main() {
    
    // get an auth token and init the database connection
    let jwt = await setup(process.env.ADMIN_USER, process.env.ADMIN_PWD);
    
    program
        .name('run-graphql')
        .description('execute various graphql queries on the database (connection details in .env)');

    program
        .command('update-tests-xhtml')
        .description('Add new xhtml data to tests without raising db flags')
        .argument('dataDir', 'json data folder')
        .action(async dataDir => {
            let resolvedDataDir = path.join(__dirname, dataDir);
            let dataFiles = await readDir(resolvedDataDir, '.json');

            for (let dataFile of dataFiles) {
                await actions.updateTestXhtml.run(dataFile, jwt);
            }
        });
    program.parse();
}

async function readDir(dirpath, ext) {
    let rd = await fs.readdir(dirpath, {withFileTypes: true})
    return rd.filter(item => !item.isDirectory() && path.extname(item.name) == ext)
        .map(item => item.path + '/' + item.name)
}
(async() => main())()
