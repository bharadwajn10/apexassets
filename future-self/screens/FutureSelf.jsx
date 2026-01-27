import { useGameState } from "../context/GameStateContext";
import { getWarnings } from "../engine/WarningEngine";

function FutureSelf() {
  const { state } = useGameState();
  const warnings = getWarnings(state);

  return (
    <div>
      <h1>Future You</h1>

      <p><strong>Goal:</strong> {state.goal || "Not set"}</p>
      <p><strong>Probability:</strong> {state.probability}%</p>

      <h3>Life Indicators</h3>
      {Object.entries(state.indicators).map(([key, value]) => (
        <p key={key}>{key}: {value}</p>
      ))}

      {warnings.length > 0 && (
        <>
          <h3>Warnings</h3>
          <ul>
            {warnings.map((w, i) => <li key={i}>{w}</li>)}
          </ul>
        </>
      )}
    </div>
  );
}

export default FutureSelf;
