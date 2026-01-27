export function calculateProbabilityChange(decision) {
  let change = 0;

  if (decision.type === "impulse_spending") change -= 10;
  if (decision.type === "investment") change += 8;
  if (decision.type === "loan") change -= 12;
  if (decision.type === "emergency_fund") change += 6;

  return change;
}
