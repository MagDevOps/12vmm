import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import ActivityRow from '../components/ActivityRow';

const ActivityList = ({ goalId }) => {
  const { goals, activities, addActivity, categories } = useApp();
  const [showAddForm, setShowAddForm] = useState(false);
  const [newActivityTitle, setNewActivityTitle] = useState('');

  const goal = goals.find(g => g.id === goalId);
  const category = categories.find(c => c.id === goal?.categoryId);
  const goalActivities = activities.filter(a => a.goalId === goalId);

  const handleAddActivity = (e) => {
    e.preventDefault();
    if (newActivityTitle.trim()) {
      addActivity(goalId, newActivityTitle.trim());
      setNewActivityTitle('');
      setShowAddForm(false);
    }
  };

  const exampleActivities = [
    'Weekly team meeting',
    'Client outreach',
    'Product development sprint',
    'Marketing campaign review',
    'Financial review'
  ];

  return (
    <div className="screen">
      <div className="screen-header">
        <div className="breadcrumb">
          <span className="category-badge" style={{ backgroundColor: category?.color }}>
            {category?.name}
          </span>
          <span className="breadcrumb-separator">›</span>
          <span className="goal-title">{goal?.title}</span>
        </div>
      </div>

      <div className="activities-header">
        <h2>Activities</h2>
        <button className="primary-button" onClick={() => setShowAddForm(!showAddForm)}>
          {showAddForm ? 'Cancel' : '+ Add Activity'}
        </button>
      </div>

      {showAddForm && (
        <div className="add-form">
          <form onSubmit={handleAddActivity}>
            <input
              type="text"
              value={newActivityTitle}
              onChange={(e) => setNewActivityTitle(e.target.value)}
              placeholder="Activity title"
              className="text-input"
              autoFocus
            />
            <button type="submit" className="primary-button">Create Activity</button>
          </form>
        </div>
      )}

      <div className="week-header">
        <div className="activity-label">Activity</div>
        <div className="weeks-grid">
          {Array.from({ length: 12 }, (_, i) => (
            <div key={i} className="week-number">W{i + 1}</div>
          ))}
        </div>
      </div>

      {goalActivities.length === 0 ? (
        <div className="empty-state">
          <p>No activities yet. Add activities to track your weekly progress!</p>
          <div className="example-chips">
            {exampleActivities.slice(0, 3).map((example, index) => (
              <button
                key={index}
                className="chip-button"
                onClick={() => {
                  addActivity(goalId, example);
                }}
              >
                + {example}
              </button>
            ))}
          </div>
        </div>
      ) : (
        <div className="activities-list">
          {goalActivities.map(activity => (
            <ActivityRow key={activity.id} activity={activity} categoryColor={category?.color} />
          ))}
        </div>
      )}
    </div>
  );
};

export default ActivityList;
