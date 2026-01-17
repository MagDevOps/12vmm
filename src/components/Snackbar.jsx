import React from 'react';
import { useApp } from '../context/AppContext';

const Snackbar = () => {
  const { snackbar, hideSnackbar } = useApp();

  if (!snackbar.show) return null;

  return (
    <div className="snackbar">
      <span className="snackbar-message">{snackbar.message}</span>
      <div className="snackbar-actions">
        {snackbar.action && (
          <button
            className="snackbar-button undo"
            onClick={() => {
              snackbar.action();
              hideSnackbar();
            }}
          >
            Undo
          </button>
        )}
        <button className="snackbar-button" onClick={hideSnackbar}>
          Dismiss
        </button>
      </div>
    </div>
  );
};

export default Snackbar;
