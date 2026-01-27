export function getWarnings(state) {
  const warnings = [];

  if (state.probability < 40) {
    warnings.push("Your future goal is at serious risk.");
  }

  if (state.indicators.stress > 70) {
    warnings.push("High stress detected. Repeated risky decisions.");
  }

  return warnings;
}
