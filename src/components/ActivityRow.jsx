import React from 'react';
import { useApp } from '../context/AppContext';

const ActivityRow = ({ activity, categoryColor }) => {
  const { toggleActivityWeek, deleteActivity } = useApp();

  const handleDelete = () => {
    if (window.confirm(`Delete activity "${activity.title}"?`)) {
      deleteActivity(activity.id);
    }
  };

  return (
    <div className="activity-row">
      <div className="activity-title">
        <span>{activity.title}</span>
        <button className="delete-button-small" onClick={handleDelete}>×</button>
      </div>
      <div className="weeks-grid">
        {activity.weekStatus.map((status, week) => (
          <button
            key={week}
            className={`week-chip ${status}`}
            style={{
              backgroundColor: status === 'completed' ? categoryColor : undefined
            }}
            onClick={() => toggleActivityWeek(activity.id, week)}
            title={`Week ${week + 1}: ${status}`}
          >
            {status === 'completed' ? '✓' : '○'}
          </button>
        ))}
      </div>
    </div>
  );
};

export default ActivityRow;
