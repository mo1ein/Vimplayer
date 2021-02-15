
""function! install()
""   let w:is_installed = system('whatis playerctl')
""   if is_installed == 'playerctl: nothing appropriate.'
"       / todo: install /
"endfunction

" default player is vlc
let s:which_player = 'vlc'

if exists('g:default_player')
    let s:which_player = g:default_player
endif

function! s:control(verb)
    " if moc is running ..."
    if s:which_player == 'mocp'
        echo "moc playing..."
        if a:verb == "Play"
            let w:info = system('mocp -G && mocp -i')
            let w:name = split(w:info, '\n')       " music title
            echo w:name[2][7:]
            sleep 2
            redraw!
        elseif a:verb == "Pnext"
            let w:info = system('mocp -f && sleep 0.2 && mocp -i')
            let w:name = split(w:info, '\n')
            echo w:name[2][7:]
            sleep 2
            redraw!
        elseif a:verb == "Prev"
            let w:info = system('mocp -r && sleep 0.2 && mocp -i')
            let w:name = split(w:info, '\n')
            echo w:name[2][7:]
            sleep 2
            redraw!
        elseif a:verb == "Current"
            let w:info = system('mocp -i')
            let w:name = split(w:info, '\n')
            echo w:name[2][7:]
            sleep 2
            redraw!
        elseif a:verb == "Shuffle"
            let w:info = system('mocp -t shuffle')
           " / todo: know which state is change /
            let w:info = 'Shuffle toggled :)'
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Repeat"                 " Repeat all playlist
            let w:info = system('mocp -t repeat')
           " / todo: know which state is change /
            let w:info = 'Repeat toggled :)'
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Autonext"
            let w:info = system('mocp -t n')
           " / todo: know which state is change /
            let w:info = 'Autonext toggled :)'
            echo w:info
            sleep 2
            redraw!
        endif
    " if other player is running ..."
    else
        "/ todo: player name show /"
        if a:verb == "Play"
            let w:is_playing = split(system('playerctl --player=' . s:which_player . ' status', ' \n'))
            if w:is_playing[0] == 'Playing'
                let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Paused: {{ title }}"'), '\n')
                echom w:info[0]
            else
                let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Playing: {{ title }}"'), '\n')
                echom w:info[0]
            endif
            sleep 2
            redraw!
        elseif a:verb == "Pnext"
            let w:info = split(system('playerctl --player=' . s:which_player . ' next && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')
            echo w:info[0]
            sleep 2
            redraw!
        elseif a:verb == "Prev"
            let w:info = split(system('playerctl --player=' . s:which_player . ' previous && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')
            echo w:info[0]
            sleep 2
            redraw!
        elseif a:verb == "Current"
            let w:info = split(system('playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')
            echo w:info[0]
            sleep 2
            redraw!
            "/ todo: add feature to see status of shuffle, repeat and autonext /"
        elseif a:verb == "Shuffle"                 " toggle shuffle
            let w:is_shuffle = split(system('playerctl --player=' . s:which_player . ' shuffle'), '\n')
            if w:is_shuffle[0] == 'Off'
                let w:info = system('playerctl --player=' . s:which_player . ' shuffle on')
                echom 'Shuffle on'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' shuffle off')
                echom 'Shuffle off'
            endif
            sleep 1
            redraw!
        elseif a:verb == "Repeat"                   " toggle repeat playlist after end all songs
            let w:is_repeat = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')
            if w:is_repeat[0] == 'Playlist'
                let w:info = system('playerctl --player=' . s:which_player . ' loop none')
                echom 'Repeat Off'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' loop playlist')
                echom 'Repeat On'
            endif
            sleep 1
            redraw!
        elseif a:verb == "Autonext"                  " toggle repeat one song forever
            let w:is_autonext = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')
            if w:is_autonext[0] == 'Track'
                let w:info = system('playerctl --player=' . s:which_player . ' loop none')
                echom 'Autonext On'
            else
                let w:info = system('playerctl --player=' . s:which_player . ' loop Track')
                echom 'Autonext Off'
            endif
            sleep 2
            redraw!
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
