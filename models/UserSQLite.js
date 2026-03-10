const db = require('../config/sqlite');
const bcrypt = require('bcryptjs');

class User {
  static async create(email, password, name, role = 'user') {
    const hashedPassword = bcrypt.hashSync(password, 10);
    const result = await db.run(
      'INSERT INTO users (email, password, name, role) VALUES (?, ?, ?, ?)',
      [email, hashedPassword, name, role]
    );
    return { insertId: result.lastID };
  }

  static async findByEmail(email) {
    return await db.get('SELECT * FROM users WHERE email = ?', [email]);
  }

  static async findById(id) {
    return await db.get(
      'SELECT id, email, name, role, created_at, updated_at FROM users WHERE id = ?',
      [id]
    );
  }

  static async getAll(limit = 10, offset = 0) {
    return await db.all(
      'SELECT id, email, name, role, created_at FROM users LIMIT ? OFFSET ?',
      [limit, offset]
    );
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
    return await db.run(
      `UPDATE users SET ${fields.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
      values
    );
  }

  static async delete(id) {
    return await db.run('DELETE FROM users WHERE id = ?', [id]);
  }

  static verifyPassword(hashedPassword, plainPassword) {
    return bcrypt.compareSync(plainPassword, hashedPassword);
  }
}

module.exports = User;
