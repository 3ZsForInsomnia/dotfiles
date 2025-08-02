local M = {}

local qaStatus = "In QA"

local sprint_name_pattern = "^POD%d+'%d+ Q%d+S%d+PI%d+$"
local function match_sprint_name(name)
  return name:match(sprint_name_pattern)
end

local daysInSprintRemaining = 3

local function get_stuck_threshold()
  -- Default: 3 days in seconds
  return 3 * 86400
end

local function get_qa_bounce_threshold()
  -- Default: 3 times
  return 3
end

local function run_cmd(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end

local function parse_json(output)
  return vim.fn.json_decode(output)
end

local function get_my_epics(project)
  local cmd = string.format('jira epic list --project "%s" --assignee $(jira me) --raw', project)
  return parse_json(run_cmd(cmd))
end

local function get_project_issues(project)
  local cmd = string.format('jira issue list --project "%s" --raw', project)
  return parse_json(run_cmd(cmd))
end

local function get_sprint_info(project)
  local current_cmd = string.format('jira sprint list --project "%s" --current --raw', project)
  local prev_cmd = string.format('jira sprint list --project "%s" --prev --raw', project)
  return {
    current = parse_json(run_cmd(current_cmd)),
    previous = parse_json(run_cmd(prev_cmd)),
  }
end

local function get_sprint_days_left(sprint)
  if not sprint or not sprint.endDate then
    return nil
  end
  local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
  local y, m, d, h, min, s = sprint.endDate:match(pattern)
  if y then
    local end_time = os.time({ year = y, month = m, day = d, hour = h, min = min, sec = s })
    local now = os.time()
    local days_left = math.ceil((end_time - now) / 86400)
    return days_left
  end
  return nil
end

local function get_latest_comment_from_data(issue)
  return issue.comments and issue.comments[1] or nil
end

local function get_issue_history_from_data(issue)
  return issue.changelog or {}
end

local function time_since_last_transition(history)
  local last_transition = nil
  for _, entry in ipairs(history) do
    if entry.field == "status" then
      last_transition = entry
    end
  end
  if last_transition and last_transition.created then
    -- Assuming last_transition.created is an ISO date string
    local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
    local y, m, d, h, min, s = last_transition.created:match(pattern)
    if y then
      local transition_time = os.time({ year = y, month = m, day = d, hour = h, min = min, sec = s })
      return os.time() - transition_time
    end
  end
  return nil
end

local function count_qa_transitions(history)
  local count = 0
  for _, entry in ipairs(history) do
    if entry.field == "status" and (entry.toString == qaStatus or entry.fromString == qaStatus) then
      count = count + 1
    end
  end
  return count
end

local function group_issues_by_assignee(issues)
  local grouped = {}
  for _, issue in ipairs(issues) do
    local assignee = issue.assignee or "Unassigned"
    grouped[assignee] = grouped[assignee] or {}
    table.insert(grouped[assignee], issue)
  end
  return grouped
end

local function analyze_attention(issues, sprint_days_left)
  local attention = {}
  local stuck_threshold = get_stuck_threshold()
  local qa_bounce_threshold = get_qa_bounce_threshold()
  for _, issue in ipairs(issues) do
    local history = get_issue_history_from_data(issue)
    local time_stuck = time_since_last_transition(history)
    local qa_bounces = count_qa_transitions(history)
    local latest_comment = get_latest_comment_from_data(issue)
    local blocked = issue.status == "Blocked"
      or (latest_comment and latest_comment.body and latest_comment.body:lower():find("block"))
    local points = issue.storyPoints or 0
    local is_urgent = sprint_days_left and sprint_days_left <= daysInSprintRemaining

    if
      blocked
      or (time_stuck and time_stuck >= stuck_threshold)
      or qa_bounces >= qa_bounce_threshold
      or (is_urgent and time_stuck and time_stuck > 86400)
    then
      table.insert(attention, {
        key = issue.key,
        summary = issue.summary,
        assignee = issue.assignee,
        status = issue.status,
        points = points,
        time_stuck = time_stuck,
        qa_bounces = qa_bounces,
        latest_comment = latest_comment and latest_comment.body or "",
        blocked = blocked,
        urgent = is_urgent,
        sprint_days_left = sprint_days_left,
      })
    end
  end
  return attention
end

local function summarize_epic_progress(epics, issues)
  local progress = {}
  for _, epic in ipairs(epics) do
    local epic_issues = {}
    local points_by_status = {}
    for _, issue in ipairs(issues) do
      if issue.epic and issue.epic.key == epic.key then
        local status = issue.status
        local points = issue.storyPoints or 0
        points_by_status[status] = (points_by_status[status] or 0) + points
        table.insert(epic_issues, issue)
      end
    end
    progress[epic.key] = {
      summary = epic.summary,
      points_by_status = points_by_status,
      issues = epic_issues,
    }
  end
  return progress
end

-- Compare sprint velocity
local function compare_sprint_velocity(current_sprint, previous_sprint)
  local function total_points(sprint)
    local sum = 0
    for _, issue in ipairs(sprint.issues or {}) do
      sum = sum + (issue.storyPoints or 0)
    end
    return sum
  end
  return {
    current = total_points(current_sprint),
    previous = total_points(previous_sprint),
  }
end

local function output_markdown(data)
  print("# Jira Project Summary\n")
  print("## Epics Assigned to You\n")
  for _, epic in ipairs(data.epics) do
    print(string.format("- %s (%s)", epic.summary, epic.key))
  end
  print("\n## Issues by Assignee\n")
  for assignee, issues in pairs(data.issues_by_assignee) do
    print(string.format("### %s", assignee))
    for _, issue in ipairs(issues) do
      print(string.format("- [%s] %s (%s) - %s pts", issue.key, issue.summary, issue.status, issue.storyPoints or 0))
    end
  end
  print("\n## Attention Needed\n")
  for _, attn in ipairs(data.attention) do
    print(
      string.format(
        "- [%s] %s (%s) - %s pts, Stuck: %s days, QA bounces: %d, Blocked: %s\n  Latest comment: %s",
        attn.key,
        attn.summary,
        attn.status,
        attn.points,
        math.floor((attn.time_stuck or 0) / 86400),
        attn.qa_bounces,
        tostring(attn.blocked),
        attn.latest_comment
      )
    )
  end
  print("\n## Epic Progress\n")
  for epic_key, progress in pairs(data.epic_progress) do
    print(string.format("### %s", progress.summary))
    for status, points in pairs(progress.points_by_status) do
      print(string.format("- %s: %d pts", status, points))
    end
  end
  print("\n## Sprint Velocity\n")
  print(
    string.format(
      "- Current sprint: %d pts\n- Previous sprint: %d pts",
      data.sprint_velocity.current,
      data.sprint_velocity.previous
    )
  )
end

-- project - e.g. POD1, POD4, SC, etc
function M.main(project)
  local epics = get_my_epics(project)
  local issues = get_project_issues(project)
  local sprint_info = get_sprint_info(project)

  local current_sprint = sprint_info.current and sprint_info.current[1] -- adjust if multiple sprints returned
  local sprint_days_left = nil
  if current_sprint and match_sprint_name(current_sprint.name) then
    sprint_days_left = get_sprint_days_left(current_sprint)
  end

  local issues_by_assignee = group_issues_by_assignee(issues)
  local attention = analyze_attention(issues, sprint_days_left)
  local epic_progress = summarize_epic_progress(epics, issues)
  local sprint_velocity = compare_sprint_velocity(sprint_info.current, sprint_info.previous)

  output_markdown({
    epics = epics,
    issues_by_assignee = issues_by_assignee,
    attention = attention,
    epic_progress = epic_progress,
    sprint_velocity = sprint_velocity,
  })
end

return M
