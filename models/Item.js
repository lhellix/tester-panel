const pool = require('../config/database');

class Item {
  static async create(userId, title, description = null, status = 'pending') {
    const query = 'INSERT INTO items (user_id, title, description, status) VALUES (?, ?, ?, ?)';
    const [result] = await pool.query(query, [userId, title, description, status]);
    return result;
  }

  static async findById(id) {
    const query = 'SELECT * FROM items WHERE id = ?';
    const [rows] = await pool.query(query, [id]);
    return rows[0];
  }

  static async getByUserId(userId, limit = 10, offset = 0) {
    const query = 'SELECT * FROM items WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?';
    const [rows] = await pool.query(query, [userId, limit, offset]);
    return rows;
  }

  static async getAll(limit = 10, offset = 0) {
    const query = 'SELECT * FROM items ORDER BY created_at DESC LIMIT ? OFFSET ?';
    const [rows] = await pool.query(query, [limit, offset]);
    return rows;
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
    const query = `UPDATE items SET ${fields.join(', ')} WHERE id = ?`;
    const [result] = await pool.query(query, values);
    return result;
  }

  static async delete(id) {
    const query = 'DELETE FROM items WHERE id = ?';
    const [result] = await pool.query(query, [id]);
    return result;
  }
}

module.exports = Item;
