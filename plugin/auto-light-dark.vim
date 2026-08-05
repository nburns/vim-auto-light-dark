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

function AfterModeChanged()
    if exists('g:loaded_lightline')
        call lightline#init()
        call lightline#colorscheme()
    endif
endfunction

call system("which defaults")
let s:has_defaults = v:shell_error ==? 0

function ApplyDesiredMode(desired_interface_mode)
    if g:interface_mode ==? a:desired_interface_mode
        " avoid unneeded changes to prevent screen flash
        return
    endif

    if a:desired_interface_mode ==? s:dark_mode
        call CallUserDarkMode()
    else
        call CallUserLightMode()
    endif

    call AfterModeChanged()
endfunction

function OnDefaultsExit(job, exit_status)
    let l:desired = a:exit_status ==? 0 ? s:dark_mode : s:light_mode
    call ApplyDesiredMode(l:desired)
endfunction

function FallbackDesiredMode()
    if (strftime('%H')) > 17 " is it past 5PM (night time)?
        return s:dark_mode
    endif

    return s:light_mode
endfunction

function SetLightDarkMode(...)
    if s:has_defaults && has('job')
        call job_start(
            \ ['defaults', 'read', '-g', 'AppleInterfaceStyle'],
            \ {'exit_cb': 'OnDefaultsExit'})
        return
    endif

    call ApplyDesiredMode(FallbackDesiredMode())
endfunction

call SetLightDarkMode()
call timer_start(g:auto_light_dark_update_ms, "SetLightDarkMode", {"repeat": -1})

let &cpo = s:save_cpo
unlet s:save_cpo
