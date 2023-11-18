-- Set the clipboard to use the unnamedplus register
vim.o.clipboard = "unnamedplus"

local function use_wsl2_clipboard()
    -- Define the clipboard utility for Windows Subsystem for Linux
    vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 1,
    }
end

local function use_linux_clipboard()
    vim.g.clipboard = {
        name = 'linux_clipboard',
        copy = {
            ['+'] = 'xclip -i -selection clipboard',
            ['*'] = 'xclip -i -selection clipboard',
        },
        paste = {
            ['+'] = 'xclip -o -selection clipboard',
            ['*'] = 'xclip -o -selection clipboard',
        },
        cache_enabled = 1,
    }
end

local function use_darwin_clipboard()
    vim.g.clipboard = {
        name = 'darwin_clipboard',
        copy = {
            ['+'] = 'pbcopy',
            ['*'] = 'pbcopy',
        },
        paste = {
            ['+'] = 'pbpaste',
            ['*'] = 'pbpaste',
        },
        cache_enabled = 1,
    }
end

local function use_windows_clipboard()
    vim.g.clipboard = {
        name = 'windows_clipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'paste.exe',
            ['*'] = 'paste.exe',
        },
        cache_enabled = 1,
    }
end

local function detect_environment()
    local uname = vim.fn.system('uname -a')
    local os_name = vim.loop.os_uname().sysname

    if uname:match("microsoft") then
        use_wsl2_clipboard()
    elseif uname:match("Linux") then
        use_linux_clipboard()
    elseif uname:match("Darwin") then
        use_darwin_clipboard()
    elseif os_name == "Windows_NT" then
        use_windows_clipboard()
    else
        -- Unknown environment
        print("Unknown environment. No clipboard set.")
        print("OS: " .. os_name .. " uname: " .. uname)
        return
    end
    print("Using clipboard: " .. vim.g.clipboard.name)
end

-- Call the function to detect the environment
detect_environment()
