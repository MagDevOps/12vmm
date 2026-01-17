import React, { createContext, useContext, useState, useEffect } from 'react';

const AppContext = createContext();

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within AppProvider');
  }
  return context;
};

const STORAGE_KEY = '12-week-year-data';

const initialCategories = [
  { id: '1', name: 'Business', color: '#3b82f6' },
  { id: '2', name: 'Health', color: '#10b981' },
  { id: '3', name: 'Relationships', color: '#f59e0b' },
  { id: '4', name: 'Personal Growth', color: '#8b5cf6' }
];

export const AppProvider = ({ children }) => {
  const [categories, setCategories] = useState(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      const data = JSON.parse(saved);
      return data.categories || initialCategories;
    }
    return initialCategories;
  });

  const [goals, setGoals] = useState(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      const data = JSON.parse(saved);
      return data.goals || [];
    }
    return [];
  });

  const [activities, setActivities] = useState(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      const data = JSON.parse(saved);
      return data.activities || [];
    }
    return [];
  });

  const [currentWeek, setCurrentWeek] = useState(1);
  const [snackbar, setSnackbar] = useState({ show: false, message: '', action: null });

  useEffect(() => {
    const data = { categories, goals, activities };
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  }, [categories, goals, activities]);

  const addCategory = (name, color) => {
    const newCategory = {
      id: Date.now().toString(),
      name,
      color: color || '#6366f1'
    };
    setCategories([...categories, newCategory]);
  };

  const deleteCategory = (id) => {
    const categoryToDelete = categories.find(c => c.id === id);
    setCategories(categories.filter(c => c.id !== id));
    setGoals(goals.filter(g => g.categoryId !== id));
    setActivities(activities.filter(a => {
      const goal = goals.find(g => g.id === a.goalId);
      return goal?.categoryId !== id;
    }));

    showSnackbar('Category deleted', () => {
      setCategories([...categories]);
      const relatedGoals = goals.filter(g => g.categoryId === id);
      setGoals([...goals]);
      const relatedActivities = activities.filter(a =>
        relatedGoals.some(g => g.id === a.goalId)
      );
      setActivities([...activities]);
    });
  };

  const addGoal = (categoryId, title, description = '') => {
    const newGoal = {
      id: Date.now().toString(),
      categoryId,
      title,
      description,
      createdAt: new Date().toISOString()
    };
    setGoals([...goals, newGoal]);
    return newGoal.id;
  };

  const updateGoal = (id, updates) => {
    setGoals(goals.map(g => g.id === id ? { ...g, ...updates } : g));
  };

  const deleteGoal = (id) => {
    const goalToDelete = goals.find(g => g.id === id);
    const relatedActivities = activities.filter(a => a.goalId === id);

    setGoals(goals.filter(g => g.id !== id));
    setActivities(activities.filter(a => a.goalId !== id));

    showSnackbar('Goal deleted', () => {
      setGoals([...goals]);
      setActivities([...activities]);
    });
  };

  const addActivity = (goalId, title) => {
    const newActivity = {
      id: Date.now().toString(),
      goalId,
      title,
      weekStatus: Array(12).fill('planned'),
      createdAt: new Date().toISOString()
    };
    setActivities([...activities, newActivity]);
    return newActivity.id;
  };

  const updateActivity = (id, updates) => {
    setActivities(activities.map(a => a.id === id ? { ...a, ...updates } : a));
  };

  const toggleActivityWeek = (activityId, week) => {
    setActivities(activities.map(a => {
      if (a.id === activityId) {
        const newStatus = [...a.weekStatus];
        newStatus[week] = newStatus[week] === 'completed' ? 'planned' : 'completed';
        return { ...a, weekStatus: newStatus };
      }
      return a;
    }));
  };

  const deleteActivity = (id) => {
    const activityToDelete = activities.find(a => a.id === id);
    setActivities(activities.filter(a => a.id !== id));

    showSnackbar('Activity deleted', () => {
      setActivities([...activities]);
    });
  };

  const showSnackbar = (message, undoAction = null) => {
    setSnackbar({ show: true, message, action: undoAction });
    setTimeout(() => {
      setSnackbar({ show: false, message: '', action: null });
    }, 5000);
  };

  const hideSnackbar = () => {
    setSnackbar({ show: false, message: '', action: null });
  };

  const getCategoryProgress = (categoryId) => {
    const categoryGoals = goals.filter(g => g.categoryId === categoryId);
    const categoryActivities = activities.filter(a =>
      categoryGoals.some(g => g.id === a.goalId)
    );

    if (categoryActivities.length === 0) return { completed: 0, total: 0, percentage: 0 };

    const totalWeeks = categoryActivities.length * 12;
    const completedWeeks = categoryActivities.reduce((sum, activity) => {
      return sum + activity.weekStatus.filter(status => status === 'completed').length;
    }, 0);

    return {
      completed: completedWeeks,
      total: totalWeeks,
      percentage: Math.round((completedWeeks / totalWeeks) * 100)
    };
  };

  const value = {
    categories,
    goals,
    activities,
    currentWeek,
    snackbar,
    setCurrentWeek,
    addCategory,
    deleteCategory,
    addGoal,
    updateGoal,
    deleteGoal,
    addActivity,
    updateActivity,
    toggleActivityWeek,
    deleteActivity,
    getCategoryProgress,
    hideSnackbar
  };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};
