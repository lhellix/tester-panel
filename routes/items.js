const express = require('express');
const { body, validationResult } = require('express-validator');
const Item = require('../models/ItemSQLite');
const { verifyToken } = require('../middleware/auth');
const router = express.Router();

// Create item
router.post('/', verifyToken, [
  body('title').notEmpty().trim(),
  body('description').optional().trim(),
  body('status').optional().isIn(['pending', 'in_progress', 'completed'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const { title, description, status } = req.body;
    const result = await Item.create(req.user.id, title, description, status);

    res.status(201).json({
      success: true,
      message: 'Item created',
      data: { id: result.insertId, user_id: req.user.id, title, description, status }
    });
  } catch (error) {
    console.error('Create item error:', error);
    res.status(500).json({ success: false, message: 'Failed to create item' });
  }
});

// Get user items
router.get('/user/:userId', verifyToken, async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);
    const offset = parseInt(req.query.offset) || 0;

    const items = await Item.getByUserId(req.params.userId, limit, offset);
    res.json({ success: true, data: items });
  } catch (error) {
    console.error('Get items error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch items' });
  }
});

// Get all items
router.get('/', verifyToken, async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);
    const offset = parseInt(req.query.offset) || 0;

    const items = await Item.getAll(limit, offset);
    res.json({ success: true, data: items });
  } catch (error) {
    console.error('Get items error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch items' });
  }
});

// Get item by ID
router.get('/:id', verifyToken, async (req, res) => {
  try {
    const item = await Item.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ success: false, message: 'Item not found' });
    }
    res.json({ success: true, data: item });
  } catch (error) {
    console.error('Get item error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch item' });
  }
});

// Update item
router.put('/:id', verifyToken, [
  body('title').optional().notEmpty().trim(),
  body('description').optional().trim(),
  body('status').optional().isIn(['pending', 'in_progress', 'completed'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const item = await Item.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ success: false, message: 'Item not found' });
    }

    // Check ownership
    if (item.user_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Forbidden' });
    }

    await Item.update(req.params.id, req.body);
    const updatedItem = await Item.findById(req.params.id);

    res.json({ success: true, message: 'Item updated', data: updatedItem });
  } catch (error) {
    console.error('Update item error:', error);
    res.status(500).json({ success: false, message: 'Failed to update item' });
  }
});

// Delete item
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const item = await Item.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ success: false, message: 'Item not found' });
    }

    // Check ownership
    if (item.user_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Forbidden' });
    }

    await Item.delete(req.params.id);
    res.json({ success: true, message: 'Item deleted' });
  } catch (error) {
    console.error('Delete item error:', error);
    res.status(500).json({ success: false, message: 'Failed to delete item' });
  }
});

module.exports = router;
