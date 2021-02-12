
""function! install()
""   let w:is_installed = system('whatis playerctl')
""   if is_installed == 'playerctl: nothing appropriate.'
"       / todo: install /
"endfunction

" default player is vlc
let s:which_player = ''

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
        echo "playing..."
        if a:verb == "Play"
            "todo: print play state"
            let w:info = system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"')
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Pnext"
            let w:info = system('playerctl --player=' . s:which_player . ' next && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"')
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Prev"
            let w:info = system('playerctl --player=' . s:which_player . ' previous && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"')
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Current"
            let w:info = system('playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"')
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Shuffle"
            "/ todo: check shuffle status and toggle /"
            let w:info = system('playerctl --player=' . s:which_player . ' shuffle off')
            "playerctl --player=s:which_player shuffle on"
           " / todo: know which state is change /
            let w:info = 'Shuffle toggled :)'
            echo w:info
            sleep 1
            redraw!
        elseif a:verb == "Repeat"                   " toggle repeat playlist after end all songs
            "/ todo: know previous state /"
           let w:info = system('playerctl --player=' . s:which_player . ' loop Playlist')
           " / todo: know which state is change /
           let w:info = 'Repeat toggled :)'
           echo w:info
           sleep 1
           redraw!
       elseif a:verb == "Autonext"                  " toggle repeat one song forever
            "(Track, previous state)"
           let w:info = system('playerctl --player=' . s:which_player ' loop Track')
           " / todo: know which state is change /
            let w:info = 'Autonext toggled :)'
            echo w:info
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
