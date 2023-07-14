import * as Q from '../queries/index.js';
import * as db from '../database/index.js';
import fs from 'fs-extra';

async function run(jsonDataFile, jwt) {

    let testBook = JSON.parse(await fs.readFile(jsonDataFile));
    
    // get book
    let dbres = await db.query(
        Q.TEST_BOOKS.GET_FOR_TOPIC(),
        { id: testBook.topicId });
    
    if (!dbres.success || dbres.data.testBooks.length == 0) {
        let err = new Error(`Could not get test books for ${testBook.topicId}`);
        throw err;
    }

    // also find the latest test book for this topic
    let latestTestBookForTopicInDb = dbres.data.testBooks.reduce((prev, current) => (prev.version > current.version) ? prev : current)

    for (let test of testBook.tests) {
        // find db entry for this test
        let dbTest = latestTestBookForTopicInDb.tests.find(t => t.testId == test.testId);
        await updateTestXhtml(dbTest, test.xhtml, jwt);
    }
}

async function updateTestXhtml(dbTest, newXhtml, jwt) {
    let dbres = await db.query(Q.TESTS.UPDATE(), {
        id: dbTest.id,
        patch: {
            xhtml: newXhtml
        } 
    }, 
    jwt);

    if (!dbres.success) {
        console.log(`Could not update test ${dbTest.id} (${dbTest.testId})\nError: ${dbres.errors}`);
    }
    else {
        console.log(`Updated test ${dbTest.id} (${dbTest.testId})`);
    }
}


export { run };