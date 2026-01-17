import React from 'react';
import { useApp } from '../context/AppContext';

const CategoryCard = ({ category, onClick }) => {
  const { getCategoryProgress, deleteCategory } = useApp();
  const progress = getCategoryProgress(category.id);

  const handleDelete = (e) => {
    e.stopPropagation();
    if (window.confirm(`Delete category "${category.name}"? This will also delete all related goals and activities.`)) {
      deleteCategory(category.id);
    }
  };

  return (
    <div className="category-card" onClick={onClick}>
      <div className="category-header">
        <div className="category-color" style={{ backgroundColor: category.color }}></div>
        <h3>{category.name}</h3>
        <button className="delete-button" onClick={handleDelete}>×</button>
      </div>
      <div className="progress-section">
        <div className="progress-bar">
          <div
            className="progress-fill"
            style={{
              width: `${progress.percentage}%`,
              backgroundColor: category.color
            }}
          ></div>
        </div>
        <div className="progress-text">
          <span className="progress-percentage">{progress.percentage}%</span>
          <span className="progress-count">
            {progress.completed} / {progress.total} weeks completed
          </span>
        </div>
      </div>
    </div>
  );
};

export default CategoryCard;
