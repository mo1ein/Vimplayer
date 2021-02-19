

""function! install()
""   let w:is_installed = system('whatis playerctl')
""   if is_installed == 'playerctl: nothing appropriate.'
"       / todo: install /
"endfunction


if exists('g:default_player')
    let s:which_player = g:default_player
else
    " default player is vlc
    let s:which_player = 'vlc'
endif


function! s:ToMilliseconds(H, M, S)
    return (a:H * 3600 + a:M * 60 + a:S ) * 1000
endfunction


function! AsyncMusicName(timer)
    let w:info = split(system('playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')
    echo w:info[0]
    let position = split(system('playerctl --player=' . s:which_player . ' position --format "{{ duration(position) }}"'), '\n')[0]
    let pos = s:ToMilliseconds('0', split(position, ':')[0], split(position, ':')[1])
    let length = split(system('playerctl --player=' . s:which_player . ' metadata --format "{{ duration(mpris:length) }}"'), '\n')[0]
    let len =  s:ToMilliseconds('0', split(length, ':')[0], split(length, ':')[1])
    ""let current  = s:ToMilliseconds(strftime('%H'),  strftime('%M'), strftime('%S'))
    let remain = len - pos

    call timer_start(remain, 'AsyncMusicName', {'Repeat':-1})
endfunction
call timer_start('0', 'AsyncMusicName', {})


function! s:control(verb)
    " if moc is running ...
    if s:which_player == 'mocp'
        if a:verb == "Play"
            let w:is_playing = split(system('mocp -i', ' \n'))[1]
            if w:is_playing == 'PLAY'
                let w:name = split(system('mocp -G && mocp -i'), '\n')
                echom 'Paused : ' . w:name[2][7:]
            else
                let w:name = split(system('mocp -G && mocp -i'), '\n')
                echom 'Playing : ' . w:name[2][7:]
            endif
        elseif a:verb == "Pnext"
            let w:name = split(system('mocp -f && sleep 0.2 && mocp -i'), '\n')
            echom 'Playing : ' . w:name[2][7:]
        elseif a:verb == "Prev"
            let w:name = split(system('mocp -r && sleep 0.2 && mocp -i'), '\n')
            echom 'Playing : ' . w:name[2][7:]
        elseif a:verb == "Current"                " current music info
            let w:name = split(system('mocp -i'), '\n')
            echom 'Now playing : ' . w:name[2][7:]
        elseif a:verb == "Shuffle"                " toggle shuffle
            let w:info = system('mocp -t shuffle')
            echom 'Shuffle toggled :)'
        elseif a:verb == "Repeat"                 " toggle repeat playlist after end all songs
            let w:info = system('mocp -t repeat')
            echom 'Repeat toggled :)'
        elseif a:verb == "Autonext"               " toggle repeat one music forever
            let w:info = system('mocp -t n')
            echom 'Autonext toggled :)'
        endif
    " if other player is running ...
    else
        if a:verb == "Play"
            let w:is_playing = split(system('playerctl --player=' . s:which_player . ' status', ' \n'))[0]
            if w:is_playing == 'Playing'
                let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Paused: {{ title }}"'), '\n')[0]
                echom w:info
            else
                let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Playing: {{ title }}"'), '\n')[0]
                echom w:info
            endif
        elseif a:verb == "Pnext"
            let w:info = split(system('playerctl --player=' . s:which_player . ' next && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
            echo w:info
        elseif a:verb == "Prev"
            let w:info = split(system('playerctl --player=' . s:which_player . ' previous && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
            echo w:info
        elseif a:verb == "Current"                 " current music info
            let w:info = split(system('playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
            echom w:info
        elseif a:verb == "Shuffle"                 " toggle shuffle
            let w:is_shuffle = split(system('playerctl --player=' . s:which_player . ' shuffle'), '\n')[0]
            if w:is_shuffle == 'Off'
                let w:info = system('playerctl --player=' . s:which_player . ' shuffle on')
                echom 'Shuffle on'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' shuffle off')
                echom 'Shuffle off'
            endif
        elseif a:verb == "Repeat"                   " toggle repeat playlist after end all songs
            let w:is_repeat = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')[0]
            if w:is_repeat == 'Playlist'
                let w:info = system('playerctl --player=' . s:which_player . ' loop none')
                echom 'Repeat Off'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' loop playlist')
                echom 'Repeat On'
            endif
        elseif a:verb == "Autonext"                  " toggle repeat one music forever
            let w:is_autonext = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')[0]
            if w:is_autonext == 'Track'
                let w:info = system('playerctl --player=' . s:which_player . ' loop none')
                echom 'Autonext On'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' loop Track')
                echom 'Autonext Off'
            endif
        endif
    endif
endfunction


"command! player         call s:control()
command! Pnext      call s:control("Pnext")         " Next music
command! Prev       call s:control("Prev")          " Previous music
command! Current    call s:control("Current")       " Current music info
command! Pp         call s:control("Play")          " Toggle play/pause
command! Repeat     call s:control("Repeat")        " Toggle repeat
command! Shuffle    call s:control("Shuffle")       " Toggle shuffle
command! Autonext   call s:control("Autonext")      " Toggel autonext
