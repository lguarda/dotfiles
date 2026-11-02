---@meta _
--- asaw: async/await for AwesomeWM, built on coroutines.
---
--- Wrap any callback-based function so it can be called as if it were
--- synchronous from inside `asaw.run`, without blocking the main loop.
---
--- ```lua
--- local asaw = require("asaw")
---
--- asaw.run(function()
---     asaw.write_file("/tmp/test", "toto")
---     local content = asaw.read_file("/tmp/test")
---     local out = asaw.spawn({ "echo", content })
---     asaw.sleep(1)
---     naughty.notify({ text = out })
--- end)
--- ```

local awful = require("awful")
local gears = require("gears")
local Gio = require("lgi").Gio

---@class asaw
local asaw = {}

local pack, unpack = table.pack, table.unpack
---{{{ Internal
--- Resume a coroutine and report any error instead of silently swallowing it.
---@param co thread
---@param ... any values returned by the pending `coroutine.yield`
local function resume(co, ...)
    local ok, err = coroutine.resume(co, ...)
    if not ok then
        gears.debug.print_error(debug.traceback(co, tostring(err)))
    end
end

--- Run `fn` inside a coroutine so it can use async functions as if they were
--- synchronous. Errors are reported through `gears.debug.print_error`.
---
--- Returns immediately at the first async call.
---@param fn fun(...: any) function to run asynchronously
---@param ... any arguments forwarded to `fn`
---@return thread co the coroutine running `fn`
function asaw.run(fn, ...)
    local co = coroutine.create(fn)
    resume(co, ...)
    return co
end

---}}}
---{{{ Wrap
--- Convert a callback-based function into its await form.
---
--- The callback **must be the last parameter** of `fun`. The returned function
--- takes the same arguments minus the callback, and returns whatever values the
--- callback receives. It must be called from inside `asaw.run`.
---
--- ```lua
--- local async_spawn = asaw.wrap(awful.spawn.easy_async)
--- asaw.run(function()
---     local stdout, stderr, reason, code = async_spawn({ "ls", "/" })
--- end)
--- ```
---
--- Safe if `fun` invokes the callback synchronously (before returning).
---@generic F: function
---@param fun F callback-last function, e.g. `function(a, b, cb)`
---@return fun(...: any): ... any await form: `function(a, b)` returning the callback's values
---@nodiscard
function asaw.wrap(fun)
    return function(...)
        local co, is_main = coroutine.running()
        if not co or is_main then
            error("asaw: async function called outside of asaw.run()", 2)
        end

        local args = pack(...)
        local waiting = false -- true once we've yielded and wait for the callback
        local early ---@type table? results if the callback fired synchronously

        args[args.n + 1] = function(...)
            if waiting then
                resume(co, ...)
            else
                early = pack(...)
            end
        end
        fun(unpack(args, 1, args.n + 1))

        if early then
            return unpack(early, 1, early.n)
        end
        waiting = true
        return coroutine.yield()
    end
end

---}}}
---{{{ Spawn
--- Await form of `awful.spawn.easy_async`.
---@async
---@type fun(cmd: string|string[]): stdout: string, stderr: string, exit_reason: "exit"|"signal", exit_code: integer
asaw.spawn = asaw.wrap(awful.spawn.easy_async)

--- Await form of `awful.spawn.easy_async_with_shell` (pipes, redirects, ...).
---@async
---@type fun(cmd: string): stdout: string, stderr: string, exit_reason: "exit"|"signal", exit_code: integer
asaw.spawn_with_shell = asaw.wrap(awful.spawn.easy_async_with_shell)
---}}}
---{{{ Files
--- Read a whole file without blocking.
---@async
---@param path string
---@return string? contents `nil` on failure
---@return string? err error message on failure
function asaw.read_file(path)
    local co = coroutine.running()
    local async_done = false
    local result ---@type table?

    local function finish(...)
        if async_done then
            resume(co, ...)
        else
            result = pack(...)
        end
    end

    Gio.File.new_for_path(path):load_contents_async(nil, function(f, task)
        local ok, contents = f:load_contents_finish(task)
        if ok then
            finish(contents, nil)
        else
            finish(nil, tostring(contents))
        end
    end)

    if result then
        return unpack(result, 1, result.n)
    end
    async_done = true
    return coroutine.yield()
end

--- Write (replace) a whole file without blocking.
---@async
---@param path string
---@param data string
---@return boolean ok
---@return string? err error message on failure
function asaw.write_file(path, data)
    local co = coroutine.running()
    local async_done = false
    local result ---@type table?

    local function finish(...)
        if async_done then
            resume(co, ...)
        else
            result = pack(...)
        end
    end

    Gio.File.new_for_path(path):replace_contents_async(
        data, nil, false, Gio.FileCreateFlags.NONE, nil,
        function(f, task)
            local ok, err = f:replace_contents_finish(task)
            if ok then
                finish(true, nil)
            else
                finish(false, tostring(err))
            end
        end)

    if result then
        return unpack(result, 1, result.n)
    end
    async_done = true
    return coroutine.yield()
end

---}}}
---{{{ Sleep
--- Suspend the current coroutine for `seconds` without blocking AwesomeWM.
---@async
---@param seconds number
function asaw.sleep(seconds)
    local co = coroutine.running()
    gears.timer.start_new(seconds, function()
        resume(co)
        return false -- one shot
    end)
    coroutine.yield()
end

---}}}
return asaw
