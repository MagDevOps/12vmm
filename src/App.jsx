import React, { useState } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import CategoryOverview from './screens/CategoryOverview';
import GoalList from './screens/GoalList';
import ActivityList from './screens/ActivityList';
import Snackbar from './components/Snackbar';
import './App.css';

const AppContent = () => {
  const [currentScreen, setCurrentScreen] = useState('overview');
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [selectedGoal, setSelectedGoal] = useState(null);
  const { snackbar } = useApp();

  const navigateToGoals = (categoryId) => {
    setSelectedCategory(categoryId);
    setCurrentScreen('goals');
  };

  const navigateToActivities = (goalId) => {
    setSelectedGoal(goalId);
    setCurrentScreen('activities');
  };

  const navigateBack = () => {
    if (currentScreen === 'activities') {
      setCurrentScreen('goals');
      setSelectedGoal(null);
    } else if (currentScreen === 'goals') {
      setCurrentScreen('overview');
      setSelectedCategory(null);
    }
  };

  const navigateHome = () => {
    setCurrentScreen('overview');
    setSelectedCategory(null);
    setSelectedGoal(null);
  };

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-content">
          {currentScreen !== 'overview' && (
            <button className="back-button" onClick={navigateBack}>
              ← Back
            </button>
          )}
          <h1 className="app-title" onClick={navigateHome} style={{ cursor: 'pointer' }}>
            12 Week Year Planner
          </h1>
          <div className="header-spacer"></div>
        </div>
      </header>

      <main className="app-main">
        {currentScreen === 'overview' && (
          <CategoryOverview onCategoryClick={navigateToGoals} />
        )}
        {currentScreen === 'goals' && (
          <GoalList
            categoryId={selectedCategory}
            onGoalClick={navigateToActivities}
          />
        )}
        {currentScreen === 'activities' && (
          <ActivityList goalId={selectedGoal} />
        )}
      </main>

      {snackbar.show && <Snackbar />}
    </div>
  );
};

const App = () => {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
};

export default App;
