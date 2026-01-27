import { createContext, useContext, useReducer } from "react";

const GameStateContext = createContext();

const initialState = {
  goal: "",
  probability: 70,
  indicators: {
    wealth: 50,
    stress: 20,
    security: 40,
    career: 50,
  },
  decisionHistory: [],
};

function reducer(state, action) {
  switch (action.type) {
    case "SET_GOAL":
      return { ...state, goal: action.payload };

    case "APPLY_DECISION":
      return {
        ...state,
        probability: state.probability + action.payload.probChange,
        indicators: {
          ...state.indicators,
          ...action.payload.indicators,
        },
        decisionHistory: [...state.decisionHistory, action.payload],
      };

    default:
      return state;
  }
}

export function GameStateProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <GameStateContext.Provider value={{ state, dispatch }}>
      {children}
    </GameStateContext.Provider>
  );
}

export function useGameState() {
  return useContext(GameStateContext);
}
