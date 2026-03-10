const express = require('express');
const { body, validationResult, query } = require('express-validator');
const User = require('../models/UserSQLite');
const { verifyToken } = require('../middleware/auth');
const router = express.Router();

// Get all users
router.get('/', verifyToken, async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);
    const offset = parseInt(req.query.offset) || 0;

    const users = await User.getAll(limit, offset);
    res.json({ success: true, data: users });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch users' });
  }
});

// Get user by ID
router.get('/:id', verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    res.json({ success: true, data: user });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch user' });
  }
});

// Get current user
router.get('/profile/me', verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    res.json({ success: true, data: user });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch profile' });
  }
});

// Update user
router.put('/:id', verifyToken, async (req, res) => {
  try {
    // Only allow users to update their own profile or admin
    if (req.user.id !== parseInt(req.params.id)) {
      return res.status(403).json({ success: false, message: 'Forbidden' });
    }

    const { name, email } = req.body;
    await User.update(req.params.id, { name, email });

    const updatedUser = await User.findById(req.params.id);
    res.json({ success: true, message: 'User updated', data: updatedUser });
  } catch (error) {
    console.error('Update user error:', error);
    res.status(500).json({ success: false, message: 'Failed to update user' });
  }
});

// Delete user
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    // Only allow users to delete their own profile or admin
    if (req.user.id !== parseInt(req.params.id)) {
      return res.status(403).json({ success: false, message: 'Forbidden' });
    }

    await User.delete(req.params.id);
    res.json({ success: true, message: 'User deleted' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ success: false, message: 'Failed to delete user' });
  }
});

module.exports = router;
