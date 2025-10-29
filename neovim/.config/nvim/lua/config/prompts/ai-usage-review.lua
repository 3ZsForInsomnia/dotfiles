local biweekly_prompt =
  [[You are helping me review my AI/LLM usage patterns from the past 14 days. Today's date is #date.

First, retrieve the relevant files using these commands:
1. Run: `fd --type f --changed-within 14d --glob 'AI Usage *.md' . '2 - Tech/22 - Tooling/22.03 - AI/Usage Tracking/'` and read all files from the past 14 days
2. Run: `fd --type f --glob '*.md' . '2 - Tech/22 - Tooling/22.03 - AI/Prompt Engineering/'` and read my prompt engineering knowledge base

Then analyze and provide:

### 1. Usage Summary
- How many AI sessions did I have over the past 14 days?
- Which models did I use?
- What categories/types of tasks?
- Average success rating and any notable patterns in ratings

### 2. What's Working
- Which interactions had high success ratings (4-5)?
- What patterns do you notice in successful sessions?
- Are there specific models, categories, or approaches that work well?

### 3. What's Not Working
- Which interactions had low ratings or required significant iteration?
- What patterns do you notice in struggles or failures?
- Are there recurring issues?

### 4. Improvement Suggestions
Based on my own prompt engineering notes:
- **Remind me**: What techniques or strategies from my notes am I not currently using that could help?
- **Suggest additions**: Based on what worked well, are there patterns or techniques I should document in my prompt engineering notes?
- **Actionable changes**: What 2-3 specific things should I try differently over the next two weeks?

### 5. Key Takeaways
Provide 3-5 bullet points of the most important insights for me to remember going forward.

Keep the analysis concise but insightful. Focus on actionable improvements rather than just stats.]]

local quarterly_prompt =
  [[You are helping me review my AI/LLM usage patterns from the past 90 days. Today's date is #date.

First, retrieve the relevant files using these commands:
1. Run: `fd --type f --changed-within 90d --glob 'AI Usage *.md' . '2 - Tech/22 - Tooling/22.03 - AI/Usage Tracking/'` and read all files from the past 90 days
2. Run: `fd --type f --glob '*.md' . '2 - Tech/22 - Tooling/22.03 - AI/Prompt Engineering/'` and read my prompt engineering knowledge base

Then analyze and provide:

### 1. 90-Day Usage Overview
- Total AI sessions over the quarter
- Models used and their frequency distribution
- Categories/types of tasks and their distribution
- Overall average success rating

### 2. Trend Analysis: Recent vs Historical
Compare the last 14 days against the previous 76 days:
- Is my success rating trending up, down, or stable?
- Am I using AI more or less frequently?
- Have my use cases or categories shifted?
- Are there models I've started using more/less?

### 3. Patterns in Success
- What consistently works well for me? (high-rated sessions)
- Which models perform best for which types of tasks?
- What patterns appear in my most successful interactions?

### 4. Patterns in Struggles
- What consistently causes issues or low ratings?
- Are there specific categories or models where I struggle?
- Have I improved on any previously difficult areas?
- Are there recurring failure modes?

### 5. Strategic Improvement Suggestions
Based on my prompt engineering knowledge base:
- **Missing techniques**: What strategies from my notes am I chronically underutilizing?
- **Knowledge gaps**: Based on my usage patterns, what should I learn more about and add to my prompt engineering notes?
- **Model optimization**: Am I using the right models for the right tasks?
- **Workflow improvements**: What systematic changes could improve my AI interactions?

### 6. Quarter Summary
Provide:
- My biggest win or improvement this quarter
- My biggest area for improvement
- 3-5 strategic recommendations for the next quarter
- Any blind spots or patterns I might not be aware of

Be analytical and strategic. Look for non-obvious patterns and provide insights that will help me level up my AI usage over the next quarter.]]

return {
  biweekly = {
    strategy = "chat",
    description = "Review AI/LLM usage patterns from the past 14 days",
    opts = { is_slash_cmd = false, auto_submit = false },
    prompts = {
      {
        role = "user",
        content = biweekly_prompt,
      },
    },
  },
  quarterly = {
    strategy = "chat",
    description = "Review AI/LLM usage patterns from the past 90 days",
    opts = { is_slash_cmd = false, auto_submit = false },
    prompts = {
      {
        role = "user",
        content = quarterly_prompt,
      },
    },
  },
}
