const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, '../data/app.db');

// Create connection with serialized mode for sync-like behavior
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) console.error('Database open error:', err);
});

db.serialize(() => {
  // Create tables
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      name TEXT NOT NULL,
      role TEXT DEFAULT 'user',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      status TEXT DEFAULT 'pending',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  `);

  // Create indices
  db.run(`CREATE INDEX IF NOT EXISTS idx_items_user_id ON items(user_id)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)`);
});

// Enable foreign keys
db.run('PRAGMA foreign_keys = ON');
db.run('PRAGMA journal_mode = WAL');

// Create wrapper functions with Promises
const promisedDb = {
  run: (sql, params = []) => {
    return new Promise((resolve, reject) => {
      db.run(sql, params, function (err) {
        if (err) reject(err);
        else resolve(this);
      });
    });
  },

  get: (sql, params = []) => {
    return new Promise((resolve, reject) => {
      db.get(sql, params, (err, row) => {
        if (err) reject(err);
        else resolve(row);
      });
    });
  },

  all: (sql, params = []) => {
    return new Promise((resolve, reject) => {
      db.all(sql, params, (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }
};

module.exports = promisedDb;

