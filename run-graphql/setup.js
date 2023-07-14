import * as db from './database/index.js';
import * as Q from './queries/index.js';
import { initDatabaseConnection } from './database/index.js';

async function setup(user, pwd) {
    await initDatabaseConnection();
    let jwt = await login(user, pwd);
    if (!jwt) {
        throw new Error("Could not login");
    }
    return jwt;
}

async function login (email, password) {
    let dbres = await db.query(Q.AUTH.LOGIN(), {
        input: {
            email, 
            password
        }
    });

    if (!dbres.success) {
        winston.error("Login error");
        throw new Error("Login error");
    }

    return dbres.data.authenticate.jwtToken;
}

export { setup }