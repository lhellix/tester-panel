const db = require('../config/sqlite');

class Item {
  static create(userId, title, description = null, status = 'pending') {
    const statement = db.prepare(
      'INSERT INTO items (user_id, title, description, status) VALUES (?, ?, ?, ?)'
    );
    const result = statement.run(userId, title, description, status);
    return { insertId: result.lastInsertRowid };
  }

  static findById(id) {
    const statement = db.prepare('SELECT * FROM items WHERE id = ?');
    return statement.get(id);
  }

  static getByUserId(userId, limit = 10, offset = 0) {
    const statement = db.prepare(
      'SELECT * FROM items WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?'
    );
    return statement.all(userId, limit, offset);
  }

  static getAll(limit = 10, offset = 0) {
    const statement = db.prepare(
      'SELECT * FROM items ORDER BY created_at DESC LIMIT ? OFFSET ?'
    );
    return statement.all(limit, offset);
  }

  static update(id, updates) {
    const allowed = ['title', 'description', 'status'];
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
    const statement = db.prepare(`UPDATE items SET ${fields.join(', ')} WHERE id = ?`);
    return statement.run(...values);
  }

  static delete(id) {
    const statement = db.prepare('DELETE FROM items WHERE id = ?');
    return statement.run(id);
  }
}

module.exports = Item;
