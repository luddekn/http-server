function is_server_running()
    local result = vim.fn.systemlist("ps aux | grep '[p]ython3 -m http.server'")
    return #result > 0
end

function StartHttpServer()
    if is_server_running() then
        print("Python HTTP server is already running.")
        return
    end

    local command = {"python3", "-m", "http.server", "8000"}

    vim.fn.jobstart(command)

    print("Python HTTP server started on port 8000.")
    vim.fn.system("xdg-open http://localhost:8000")
end

function StopHttpServer()
    local result = vim.fn.systemlist("ps aux | grep '[p]ython3 -m http.server'")
    
    if #result == 0 then
        print("No HTTP server is running.")
        return
    end

    local pid = result[1]:match("%S+")
    vim.fn.system("kill " .. pid)

    print("Python HTTP server stopped.")
end

vim.api.nvim_create_user_command("StartHTTPServer", function ()
    StartHttpServer()
end, {})

vim.api.nvim_create_user_command("StopHttpServer", function ()
    StopHttpServer()
end, {})
