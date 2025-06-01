#!/usr/bin/env bash
# check_holiday.sh: Checks if today is a holiday and sets outputs for GitHub Actions

# Cross-platform timezone validation
if ! today=$(TZ="$1" date +%F 2>/dev/null); then
  echo "❌ Invalid timezone: '$1'"
  exit 2
fi

echo "📅 Local date in timezone '$1': $today"

is_holiday=false
IFS=',' read -ra HOLIDAY_ARRAY <<< "$2"
for holiday in "${HOLIDAY_ARRAY[@]}"; do
  # Trim leading/trailing whitespace from each holiday
  holiday_trimmed="$(echo "$holiday" | xargs)"
  if [[ "$holiday_trimmed" == "$today" ]]; then
    is_holiday=true
    break
  fi
done

echo "on_holiday=$is_holiday" >> $GITHUB_OUTPUT

if [[ "$is_holiday" == "true" && "$3" == "true" ]]; then
  echo "🛑 It's a holiday! Failing the job as requested."
  exit 1
fi

if [[ "$is_holiday" == "true" ]]; then
  echo "🎉 It's a holiday! Marking on_holiday=true and exiting normally."
else
  echo "✅ Not a holiday. Continuing workflow."
fi
