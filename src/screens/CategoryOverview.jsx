import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import CategoryCard from '../components/CategoryCard';

const CategoryOverview = ({ onCategoryClick }) => {
  const { categories, addCategory } = useApp();
  const [showAddForm, setShowAddForm] = useState(false);
  const [newCategoryName, setNewCategoryName] = useState('');
  const [newCategoryColor, setNewCategoryColor] = useState('#6366f1');

  const handleAddCategory = (e) => {
    e.preventDefault();
    if (newCategoryName.trim()) {
      addCategory(newCategoryName.trim(), newCategoryColor);
      setNewCategoryName('');
      setNewCategoryColor('#6366f1');
      setShowAddForm(false);
    }
  };

  const colors = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#ec4899'];

  return (
    <div className="screen">
      <div className="screen-header">
        <h2>Your Categories</h2>
        <button className="primary-button" onClick={() => setShowAddForm(!showAddForm)}>
          {showAddForm ? 'Cancel' : '+ Add Category'}
        </button>
      </div>

      {showAddForm && (
        <div className="add-form">
          <form onSubmit={handleAddCategory}>
            <input
              type="text"
              value={newCategoryName}
              onChange={(e) => setNewCategoryName(e.target.value)}
              placeholder="Category name"
              className="text-input"
              autoFocus
            />
            <div className="color-picker">
              {colors.map(color => (
                <button
                  key={color}
                  type="button"
                  className={`color-option ${newCategoryColor === color ? 'selected' : ''}`}
                  style={{ backgroundColor: color }}
                  onClick={() => setNewCategoryColor(color)}
                />
              ))}
            </div>
            <button type="submit" className="primary-button">Create Category</button>
          </form>
        </div>
      )}

      {categories.length === 0 ? (
        <div className="empty-state">
          <p>No categories yet. Create your first category to get started!</p>
          <div className="example-chips">
            <button
              className="chip-button"
              onClick={() => {
                addCategory('Business', '#3b82f6');
              }}
            >
              + Business
            </button>
            <button
              className="chip-button"
              onClick={() => {
                addCategory('Health', '#10b981');
              }}
            >
              + Health
            </button>
            <button
              className="chip-button"
              onClick={() => {
                addCategory('Relationships', '#f59e0b');
              }}
            >
              + Relationships
            </button>
          </div>
        </div>
      ) : (
        <div className="category-grid">
          {categories.map(category => (
            <CategoryCard
              key={category.id}
              category={category}
              onClick={() => onCategoryClick(category.id)}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export default CategoryOverview;
