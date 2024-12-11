local server_job_id = nil

function is_server_running()
    local result = vim.fn.systemlist("ps aux | grep '[p]ython3 -m http.server'")
    return #result > 0  -- If there's at least one process, it means the server is running
end

function StartHttpServer()
    if is_server_running() then
        print("Python HTTP server is already running.")
        return
    end

    local command = {"python3", "-m", "http.server", "8000"}

    server_job_id = vim.fn.jobstart(command, {
        on_exit = function(_, code)
            if code == 0 then
                print("Python HTTP server stopped.")
            else
                print("Error: Server exited with code " .. code)
            end
        end,
    })

    if server_job_id > 0 then
        print("Python HTTP server started on port 8000.")
        vim.fn.system("xdg-open http://localhost:8000")
    else
        print("Failed to start the HTTP server.")
    end
end

function StopHttpServer()
    if not server_job_id or server_job_id <= 0 then
        print("No HTTP server is running.")
        return
    end

    vim.fn.jobstop(server_job_id)
    print("Python HTTP server stopped.")
    server_job_id = nil
end

-- Register commands
vim.api.nvim_create_user_command("StartHTTPServer", function ()
    StartHttpServer()
end, {})

vim.api.nvim_create_user_command("StopHttpServer", function ()
    StopHttpServer()
end, {})
