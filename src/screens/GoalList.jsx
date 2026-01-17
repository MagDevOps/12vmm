import React, { useState } from 'react';
import { useApp } from '../context/AppContext';

const GoalList = ({ categoryId, onGoalClick }) => {
  const { categories, goals, addGoal, deleteGoal } = useApp();
  const [showAddForm, setShowAddForm] = useState(false);
  const [newGoalTitle, setNewGoalTitle] = useState('');
  const [newGoalDescription, setNewGoalDescription] = useState('');

  const category = categories.find(c => c.id === categoryId);
  const categoryGoals = goals.filter(g => g.categoryId === categoryId);

  const handleAddGoal = (e) => {
    e.preventDefault();
    if (newGoalTitle.trim()) {
      addGoal(categoryId, newGoalTitle.trim(), newGoalDescription.trim());
      setNewGoalTitle('');
      setNewGoalDescription('');
      setShowAddForm(false);
    }
  };

  const handleDelete = (goalId) => {
    if (window.confirm('Delete this goal? This will also delete all related activities.')) {
      deleteGoal(goalId);
    }
  };

  const exampleGoals = [
    'Increase revenue by 25%',
    'Launch new product',
    'Exercise 4x per week',
    'Read 12 books',
    'Build stronger relationships'
  ];

  return (
    <div className="screen">
      <div className="screen-header">
        <div className="category-badge" style={{ backgroundColor: category?.color }}>
          {category?.name}
        </div>
        <h2>Goals</h2>
        <button className="primary-button" onClick={() => setShowAddForm(!showAddForm)}>
          {showAddForm ? 'Cancel' : '+ Add Goal'}
        </button>
      </div>

      {showAddForm && (
        <div className="add-form">
          <form onSubmit={handleAddGoal}>
            <input
              type="text"
              value={newGoalTitle}
              onChange={(e) => setNewGoalTitle(e.target.value)}
              placeholder="Goal title"
              className="text-input"
              autoFocus
            />
            <textarea
              value={newGoalDescription}
              onChange={(e) => setNewGoalDescription(e.target.value)}
              placeholder="Description (optional)"
              className="textarea-input"
              rows="3"
            />
            <button type="submit" className="primary-button">Create Goal</button>
          </form>
        </div>
      )}

      {categoryGoals.length === 0 ? (
        <div className="empty-state">
          <p>No goals yet. Add your first goal for this 12-week period!</p>
          <div className="example-chips">
            {exampleGoals.slice(0, 3).map((example, index) => (
              <button
                key={index}
                className="chip-button"
                onClick={() => {
                  addGoal(categoryId, example, '');
                }}
              >
                + {example}
              </button>
            ))}
          </div>
        </div>
      ) : (
        <div className="goals-list">
          {categoryGoals.map(goal => (
            <div key={goal.id} className="goal-card" onClick={() => onGoalClick(goal.id)}>
              <div className="goal-header">
                <h3>{goal.title}</h3>
                <button
                  className="delete-button"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleDelete(goal.id);
                  }}
                >
                  ×
                </button>
              </div>
              {goal.description && (
                <p className="goal-description">{goal.description}</p>
              )}
              <div className="goal-footer">
                <span className="click-hint">Click to manage activities →</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default GoalList;
