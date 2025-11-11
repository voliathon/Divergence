--[[
    Addon metadata: This tells Windower the addon's name,
    author, version, and the commands it uses.
]]
_addon.name = 'DivergenceTimes'
_addon.author = 'Voliathon'
_addon.version = '1.0.1' -- Version updated
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
    
    Simulates the next ~6 hours for a single zone and builds the
    "Open (30m) > Closed (60m) > Open (60m)" string.
    
    Parameters:
    - zone: The string name of the zone (e.g., 'San d'Oria').
    - start_cycle_minute: The current minute (0-119) to start from.
    
    Returns:
    - A formatted string with color codes.
]]
local function build_timeline_string(zone, start_cycle_minute)
    local timeline_str = ""
    local sim_minute = start_cycle_minute
    
    -- Loop 3 times to get the current state + the next 2 states
    for i = 1, 3 do
        -- Modulo 120 ensures the simulation wraps around the 2-hour cycle
        local check_minute = sim_minute % 120
        
        -- Get the status and duration for this simulated block
        local status, duration = get_status_at_minute(zone, check_minute)
        
        -- Define Windower color codes
        local status_color = (status == 'Open') and '\31\204' or '\31\160' -- Green for Open, Grey for Closed
        local reset_color = '\31\207' -- Default chat color
        
        -- Build the string part, e.g., "Open (30m)"
        timeline_str = timeline_str .. string.format("%s%s (%dm)%s", status_color, status, duration, reset_color)
        
        -- Add the arrow separator, but not on the last loop
        if i < 3 then
            timeline_str = timeline_str .. " > "
        end
        
        -- Advance the simulation time
        sim_minute = sim_minute + duration
    end
    
    -- Return the fully formatted line, e.g., " San d'Oria : Open (30m) > ..."
    -- '%-12s' pads the zone name to 12 characters for clean alignment
    return string.format(' %-12s: %s', zone, timeline_str)
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
    local header_message = '--- Divergence Schedule (JST: '.. time_str ..') ---'
    
    -- windower.add_to_chat(color, message) prints to the local chat log
    -- Color 207 is a light purple
    windower.add_to_chat(207, '-------' .. header_message .. '-------')

    -- Step 5: Loop through zones and print their timelines
    for _, zone in ipairs(ordered_zones) do
        -- Call our helper function to build the forecast string
        local zone_message = build_timeline_string(zone, current_cycle_minute)
        
        -- Print the final string to the chat log
        windower.add_to_chat(207, '-------' .. zone_message .. '-------')
    end
end)