--[[
    Addon metadata: This tells Windower the addon's name,
    author, version, and the commands it uses.
]]
_addon.name = 'DivergenceTimes'
_addon.author = 'Voliathon'
_addon.version = '2.1.2' -- Version updated for bug fix
_addon.commands = {'divtimes', 'div'}

-- Copyright (c) 2025 Voliathon
-- This addon is for personal use and may be freely distributed
-- and modified, provided this copyright notice remains intact.


--[[
    Schedule Data
    This table stores the static 120-minute (2-hour) repeating schedule
    for each Dynamis Divergence zone, anchored to 0:00 JST.
    
    Structure: {start_minute_of_cycle, end_minute_of_cycle, "Status"}
]]
local zone_schedules = {
    ['San d\'Oria'] = {
        {0, 60, 'Open'},    -- JST 0:00-1:00 (Open)
        {60, 120, 'Closed'}  -- JST 1:00-2:00 (Closed)
    },
    ['Bastok'] = {
        {0, 30, 'Closed'},   -- JST 0:00-0:30 (Closed)
        {30, 90, 'Open'},    -- JST 0:30-1:30 (Open)
        {90, 120, 'Closed'}  -- JST 1:30-2:00 (Closed)
    },
    ['Windurst'] = {
        {0, 60, 'Closed'},   -- JST 0:00-1:00 (Closed)
        {60, 120, 'Open'}    -- JST 1:00-2:00 (Open)
    },
    ['Jeuno'] = {
        {0, 30, 'Open'},    -- JST 0:00-0:30 (Open)
        {30, 90, 'Closed'},  -- JST 0:30-1:30 (Closed)
        {90, 120, 'Open'}    -- JST 1:30-2:00 (Open)
    }
}

-- ** Color codes for each zone name (Using brighter colors) **
local zone_colors = {
    ['San d\'Oria'] = '\31\004', -- Bright Red (/say)
    ['Bastok'] = '\31\208',     -- Bright Blue (Addon)
    ['Windurst'] = '\31\204',   -- Lime Green (/party)
    ['Jeuno'] = '\31\001',      -- White/Yellow (/emote)
}
local reset_color = '\31\207' -- Default light purple


--[[
    Function: get_status_at_minute
    
    Checks a zone's schedule against a specific minute in the cycle (0-119).
    
    Parameters:
    - zone_name: The string name of the zone (e.g., 'Bastok').
    - minute_in_cycle: A number from 0 to 119.
    
    Returns:
    - The status ("Open" or "Closed").
    - The number of minutes remaining in that status block.
]]
local function get_status_at_minute(zone_name, minute_in_cycle)
    local schedule = zone_schedules[zone_name]
    
    -- Loop through the schedule blocks (e.g., {0, 30, 'Closed'})
    for _, block in ipairs(schedule) do
        local start_min = block[1]
        local end_min = block[2]
        local status = block[3]
        
        -- Check if our current minute falls within this block
        if minute_in_cycle >= start_min and minute_in_cycle < end_min then
            -- Found it. Return the status and time left.
            return status, (end_min - minute_in_cycle)
        end
    end
    
    -- Fallback in case something goes wrong
    return 'Unknown', 0
end


--[[
    Function: build_timeline_string
    
    Builds the formatted string for a single zone's CURRENT status.
    
    Parameters:
    - zone: The string name of the zone (e.g., 'San d'Oria').
    - start_cycle_minute: The current minute (0-119) to start from.
    - jst_minutes_today: The total minutes past JST midnight.
    
    Returns:
    - A formatted string with color codes.
]]
local function build_timeline_string(zone, start_cycle_minute, jst_minutes_today)
    local timeline_str = ""

    -- ** THE FIX: These lines MUST come first **
    -- We get the status and duration *before* we try to use them
    local status, duration = get_status_at_minute(zone, start_cycle_minute)
    
    -- Define Windower color codes for the status text
    local status_color = (status == 'Open') and '\31\204' or '\31\160' -- Green for Open, Grey for Closed
    
    -- Calculate the exact JST time of the next change
    local change_time_in_minutes = jst_minutes_today + duration
    local change_hour = math.floor(change_time_in_minutes / 60) % 24
    local change_minute = change_time_in_minutes % 60
    local time_string = string.format("%02d:%02d", change_hour, change_minute)
    
    -- New wording based on status
    if status == 'Open' then
        timeline_str = string.format("%sOngoing (%d minutes remaining)%s - Closes at %s", status_color, duration, reset_color, time_string)
    else
        timeline_str = string.format("%sClosed for (%d more minutes)%s - Opens at %s", status_color, duration, reset_color, time_string)
    end
    
    -- Add pipe and zone-specific color
    -- Get the zone's color, or use the reset_color as a fallback
    local zone_color = zone_colors[zone] or reset_color
    
    -- Return the fully formatted line, e.g., "| San d'Oria : ..."
    -- '%-12s' pads the zone name to 12 characters for clean alignment
    return string.format(' | %s%-12s%s: %s', zone_color, zone, reset_color, timeline_str)
end


--[[
    Main Event Handler
    
    This function runs when the user types '//divtimes' or '//div'.
]]
windower.register_event('addon command', function(...)
    -- Step 1: Get the current time in UTC
    -- 'os.date("!*t")' gets the time in UTC, ignoring local timezone
    local utc = os.date('!*t')
    
    -- Step 2: Convert UTC to JST (JST is UTC+9)
    -- We calculate total minutes past midnight for both
    local utc_minutes_today = (utc.hour * 60) + utc.min
    local jst_minutes_today = utc_minutes_today + 540 -- 540 minutes = 9 hours
    
    -- Step 3: Find our current position in the 120-minute cycle
    -- The modulo operator (%) gives us the remainder
    local current_cycle_minute = jst_minutes_today % 120

    -- Define the order to print zones
    local ordered_zones = {'San d\'Oria', 'Bastok', 'Windurst', 'Jeuno'}

    -- Step 4: Print the Header
    -- Calculate JST hour for display (e.g., (14 + 9) % 24 = 23)
    local jst_hour = (utc.hour + 9) % 24
    local time_str = string.format("%02d:%02d", jst_hour, utc.min)
    
    -- New header text and format
    local header_message = '*** Divergence Shared Schedule (Current time in Japan(JST): '.. time_str ..') ***'
    
    -- windower.add_to_chat(color, message) prints to the local chat log
    -- Color 207 is a light purple
    windower.add_to_chat(207, header_message)

    -- Step 5: Loop through zones and print their timelines
    for _, zone in ipairs(ordered_zones) do
        -- Call our helper function to build the forecast string
        local zone_message = build_timeline_string(zone, current_cycle_minute, jst_minutes_today)
        
        -- Removed the '-------' wrapper
        windower.add_to_chat(207, zone_message)
    end
end)