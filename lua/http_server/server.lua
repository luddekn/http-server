local server_job_id = nil

function StartHttpServer()
	local command = { "python3", "-m", "http.server", "8000" }

	server_job_id = vim.fn.jobstart(command, {
		on_stdout = function(_, data, _)
			if data then
				for _, line in ipairs(data) do
					print(line)
				end
			end
		end,
		on_stderr = function(_, data, _)
			if data then
				for _, line in ipairs(data) do
					print("Error: " .. line)
				end
			end
		end,
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
    if server_job_id then
        vim.fn.jobstop(server_job_id)
        print("Python HTTP server stopped.")
        server_job_id = nil
    else
        print("No HTTP server is running.")
    end
end

vim.api.nvim_create_user_command("StartHTTPServer", function ()
    StartHttpServer()
end, {})

vim.api.nvim_create_user_command("StopHttpServer", function ()
    StopHttpServer()
end, {})
