# Future Self Module

## Overview

The **Future Self module** is a core analytical and reflective component of the *Future You* platform.
Its purpose is to help users visualize the long-term consequences of financial decisions made during gameplay by simulating how those decisions influence future life outcomes.

This module focuses on **behavioural awareness and reflection**, rather than direct instruction or automated advice.

---

## Objectives

* Visualize long-term impact of short-term financial decisions
* Track probability of achieving a user-defined future goal
* Monitor key life indicators affected by decisions
* Generate meaningful warnings and feedback
* Support human-led facilitation (self-help groups, community leaders)

---

## Scope of Responsibility

The Future Self module is responsible for:

* Maintaining global game state related to the user’s future
* Calculating and updating goal achievement probability
* Tracking life indicators (wealth, stress, security, career)
* Detecting risk patterns and generating warnings
* Presenting a consolidated future visualization to the user

The module does **not**:

* Control story progression
* Generate scenarios
* Manage levels or gameplay flow

Those responsibilities belong to the **Story Mode module**.

---

## Folder Structure

```
future-self/
├── components/
│   ├── FutureAvatar.jsx
│   ├── ProbabilityBar.jsx
│   └── WarningAlert.jsx
│
├── context/
│   └── GameStateContext.js
│
├── data/
│   ├── goals.js
│   ├── futureMessages.js
│   └── indicators.js
│
├── engine/
│   ├── ProbabilityEngine.js
│   └── WarningEngine.js
│
├── screens/
│   └── FutureSelf.jsx
│
└── README.md
```

---

## Core Concepts

### 1. Goal Selection and Probability

Each user selects a long-term life goal (e.g., financial independence, owning a house).
The system assigns an initial probability of achieving this goal.

* Probability changes dynamically based on decisions
* Changes may be positive or negative
* Effects can be immediate or delayed

This reflects real-world uncertainty rather than deterministic outcomes.

---

### 2. Life Indicators

The module tracks multiple dimensions of a user’s future:

* **Wealth** – financial resources and savings
* **Stress** – psychological and emotional pressure
* **Security** – resilience against emergencies
* **Career** – job stability and growth

A single decision may positively impact one indicator while harming another.

---

### 3. Decision History and Patterns

The module maintains a history of decisions received from Story Mode.
Warnings and feedback are based on **patterns over time**, not isolated actions.

Examples:

* Repeated reliance on loans
* Consistent avoidance of savings
* Frequent impulse-driven decisions

---

### 4. Warnings and Feedback

Warnings are designed to be:

* Non-judgmental
* Context-aware
* Gradual in severity

Types of feedback include:

* Early nudges
* Risk alerts
* Critical future warnings

The system avoids excessive alerts and does not replace human guidance.

---

## Integration with Story Mode

Story Mode dispatches decisions to the shared game state.

Example integration:

```javascript
dispatch({
  type: "APPLY_DECISION",
  payload: {
    type: "loan",
    probChange: -12,
    indicators: { stress: +10 }
  }
});
```

The Future Self module:

* Reads the updated state
* Updates probability and indicators
* Evaluates warning conditions
* Reflects changes in the Future Self screen

The two modules remain loosely coupled.

---

## Engines

### Probability Engine

* Rule-based and transparent
* No machine learning or black-box logic
* Designed for explainability

Responsible for:

* Adjusting goal probability
* Applying cumulative and delayed effects

---

### Warning Engine

* Evaluates thresholds and behaviour patterns
* Generates warnings only when necessary
* Supports facilitator-led explanations

---

## User Experience Goals

The Future Self screen is intended to:

* Encourage reflection
* Help users understand cause-and-effect relationships
* Support informed decision-making

It should not:

* Provide direct financial advice
* Overwhelm users with technical details
* Replace personal or community guidance

---

## Accessibility and Deployment Considerations

* Offline-first design using local state
* Minimal text and simple visuals
* Easily extendable for regional languages
* Suitable for low-end devices

---

## Ethics and Safety

* No real financial data is collected
* No personalized financial advice is given
* The system functions as an educational simulation only
* All logic is transparent and reviewable

---

## Future Enhancements (Out of Scope for MVP)

* Multiple future timelines (best, current, worst)
* Avatar aging and emotional states
* Replay and alternative decision paths
* Community leader dashboards
* Printable reflection summaries

---

## Ownership and Contribution

This module is owned by the **Future Self development team**.
Any changes to core logic should be reviewed to ensure behavioural integrity and consistency with the platform’s educational goals.


