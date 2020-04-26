if exists('g:loaded_auto_light_dark')
    finish " load only once
endif

let g:loaded_auto_light_dark = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:auto_light_dark_update_ms")
    let g:auto_light_dark_update_ms = 10000 " 10 seconds
endif

let s:dark_mode = "dark"
let s:light_mode = "light"

let g:interface_mode = "unknown"

function CallUserDarkMode()
    let g:interface_mode = s:dark_mode
    call call(function("DarkMode"), [])
endfunction

function CallUserLightMode()
    let g:interface_mode = s:light_mode
    call call(function("LightMode"), [])
endfunction

function DesiredInterfaceMode()
    call system("which defaults")
    if v:shell_error ==? 0 " if we can read stuff out of defaults
        call system("defaults read -g AppleInterfaceStyle")
        if v:shell_error ==? 0
            return s:dark_mode
        else
            return s:light_mode
        endif
    else " fallback for non macos
        if (strftime('%H')) > 17 " is it past 5PM (night time)?
            return s:dark_mode
        else
            return s:light_mode
        endif
    endif
endfunction

function SetLightDarkMode(...)
    if g:interface_mode ==? DesiredInterfaceMode()
        " avoid unneeded changes to prevent screen flash
        return
    endif

    if DesiredInterfaceMode() ==? s:dark_mode
        call CallUserDarkMode()
    else
        call CallUserLightMode()
    endif
endfunction

call SetLightDarkMode()
call timer_start(g:auto_light_dark_update_ms, "SetLightDarkMode", {"repeat": -1})

let &cpo = s:save_cpo
unlet s:save_cpo
