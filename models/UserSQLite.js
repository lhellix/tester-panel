const db = require('../config/sqlite');
const bcrypt = require('bcryptjs');

class User {
  static create(email, password, name, role = 'user') {
    const hashedPassword = bcrypt.hashSync(password, 10);
    const statement = db.prepare(
      'INSERT INTO users (email, password, name, role) VALUES (?, ?, ?, ?)'
    );
    const result = statement.run(email, hashedPassword, name, role);
    return { insertId: result.lastInsertRowid };
  }

  static findByEmail(email) {
    const statement = db.prepare('SELECT * FROM users WHERE email = ?');
    return statement.get(email);
  }

  static findById(id) {
    const statement = db.prepare(
      'SELECT id, email, name, role, created_at, updated_at FROM users WHERE id = ?'
    );
    return statement.get(id);
  }

  static getAll(limit = 10, offset = 0) {
    const statement = db.prepare(
      'SELECT id, email, name, role, created_at FROM users LIMIT ? OFFSET ?'
    );
    return statement.all(limit, offset);
  }

  static update(id, updates) {
    const allowed = ['name', 'email'];
    const fields = [];
    const values = [];

    for (const [key, value] of Object.entries(updates)) {
      if (allowed.includes(key) && value !== undefined) {
        fields.push(`${key} = ?`);
        values.push(value);
      }
    }

    if (fields.length === 0) return null;

    values.push(id);
    const statement = db.prepare(`UPDATE users SET ${fields.join(', ')} WHERE id = ?`);
    return statement.run(...values);
  }

  static delete(id) {
    const statement = db.prepare('DELETE FROM users WHERE id = ?');
    return statement.run(id);
  }

  static verifyPassword(hashedPassword, plainPassword) {
    return bcrypt.compareSync(plainPassword, hashedPassword);
  }
}

module.exports = User;
