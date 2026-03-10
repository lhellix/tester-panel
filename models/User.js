const pool = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
  static async create(email, password, name, role = 'user') {
    const hashedPassword = await bcrypt.hash(password, 10);
    const query = 'INSERT INTO users (email, password, name, role) VALUES (?, ?, ?, ?)';
    const [result] = await pool.query(query, [email, hashedPassword, name, role]);
    return result;
  }

  static async findByEmail(email) {
    const query = 'SELECT * FROM users WHERE email = ?';
    const [rows] = await pool.query(query, [email]);
    return rows[0];
  }

  static async findById(id) {
    const query = 'SELECT id, email, name, role, created_at, updated_at FROM users WHERE id = ?';
    const [rows] = await pool.query(query, [id]);
    return rows[0];
  }

  static async getAll(limit = 10, offset = 0) {
    const query = 'SELECT id, email, name, role, created_at FROM users LIMIT ? OFFSET ?';
    const [rows] = await pool.query(query, [limit, offset]);
    return rows;
  }

  static async update(id, updates) {
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
    const query = `UPDATE users SET ${fields.join(', ')} WHERE id = ?`;
    const [result] = await pool.query(query, values);
    return result;
  }

  static async delete(id) {
    const query = 'DELETE FROM users WHERE id = ?';
    const [result] = await pool.query(query, [id]);
    return result;
  }

  static async verifyPassword(hashedPassword, plainPassword) {
    return bcrypt.compare(plainPassword, hashedPassword);
  }
}

module.exports = User;
