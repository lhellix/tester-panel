const db = require('../config/sqlite');

class Item {
  static async create(userId, title, description = null, status = 'pending') {
    const result = await db.run(
      'INSERT INTO items (user_id, title, description, status) VALUES (?, ?, ?, ?)',
      [userId, title, description, status]
    );
    return { insertId: result.lastID };
  }

  static async findById(id) {
    return await db.get('SELECT * FROM items WHERE id = ?', [id]);
  }

  static async getByUserId(userId, limit = 10, offset = 0) {
    return await db.all(
      'SELECT * FROM items WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?',
      [userId, limit, offset]
    );
  }

  static async getAll(limit = 10, offset = 0) {
    return await db.all(
      'SELECT * FROM items ORDER BY created_at DESC LIMIT ? OFFSET ?',
      [limit, offset]
    );
  }

  static async update(id, updates) {
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
    return await db.run(
      `UPDATE items SET ${fields.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
      values
    );
  }

  static async delete(id) {
    return await db.run('DELETE FROM items WHERE id = ?', [id]);
  }
}

module.exports = Item;
