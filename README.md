# 12 Week Year Planner

A fully functional React app to help you plan and track your goals using the 12 Week Year methodology. Focus on what matters most with category-based goal tracking and weekly activity completion.

## Features

- **Category Management**: Organize your goals into customizable categories with color coding
- **Goal Tracking**: Create and manage goals within each category
- **Weekly Activity Tracking**: Track activities across all 12 weeks with visual week-by-week status
- **Progress Visualization**: See your progress with percentage bars and completion counts
- **Quick Actions**: Example chips to quickly add categories, goals, and activities
- **Undo Support**: Snackbar with undo functionality when deleting items
- **Local Storage**: All your data is saved automatically in your browser
- **Responsive Design**: Works beautifully on desktop and mobile devices

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Clone the repository or navigate to the project directory

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The app will open automatically in your browser at `http://localhost:3000`

### Building for Production

To create a production build:
```bash
npm run build
```

The optimized files will be in the `dist` folder.

## How to Use

### 1. Create Categories
- Click "Add Category" on the home screen
- Choose a name and color for your category
- Or use the quick action chips (Business, Health, Relationships)

### 2. Add Goals
- Click on any category to view its goals
- Click "Add Goal" to create a new goal
- Add a title and optional description
- Or use the example goal chips

### 3. Track Activities
- Click on any goal to view its activities
- Click "Add Activity" to create weekly tasks
- Click on the week chips (W1-W12) to mark them as completed
- Track your progress across all 12 weeks

### 4. Monitor Progress
- Return to the home screen to see overall progress by category
- Progress bars show completion percentage
- See how many weeks you've completed out of total planned weeks

## Project Structure

```
src/
├── App.jsx                    # Main app component with routing
├── App.css                    # Global styles
├── index.jsx                  # App entry point
├── context/
│   └── AppContext.jsx         # State management with Context API
├── screens/
│   ├── CategoryOverview.jsx   # Category list and overview
│   ├── GoalList.jsx          # Goals for selected category
│   └── ActivityList.jsx      # Activities and week tracking
└── components/
    ├── CategoryCard.jsx       # Category display card
    ├── ActivityRow.jsx        # Activity with week chips
    └── Snackbar.jsx          # Undo notification
```

## Technologies Used

- **React 18**: Modern React with hooks
- **Context API**: Simple and effective state management
- **Local Storage**: Persistent data storage
- **Webpack**: Module bundling
- **CSS3**: Modern styling with animations

## Features in Detail

### Category Progress Calculation
Progress is calculated based on completed weeks across all activities in a category:
- Each activity has 12 weeks
- Completed weeks / Total weeks = Progress percentage

### Data Persistence
All data (categories, goals, activities) is automatically saved to browser localStorage and restored on page reload.

### Undo Functionality
When you delete a category, goal, or activity, a snackbar appears with an undo button, giving you 5 seconds to reverse the action.

## License

MIT
