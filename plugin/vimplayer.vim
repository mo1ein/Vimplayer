
function! s:control(verb)
    " if player is runnig/installed?
    let w:detect_player = system('pgrep cmus')
    let w:which_player = 'not'
    if w:detect_player == ''
        "todo: when both running? decision"
        let w:detect_player = system('pgrep moc')
        if w:detect_player == ''
            echo "Please run/install your player "
        else
            let w:which_player = 'moc'
        endif
    else
        let w:which_player = 'cmus'
    endif

    " if moc is running ..."
    if w:which_player == 'moc'
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
    " if cmus is running ..."
    elseif w:which_player == 'cmus'
        echo "cmus playing..."
        if a:verb == "Play"
            let w:info = system('cmus-remote -u -Q')
            let w:name = split(w:info, '\n')       " music title
            echo w:name[6][10:] '-' w:name[4][10:]
            sleep 2
            redraw!
        elseif a:verb == "Pnext"
            let w:info = system('cmus-remote --next -Q')
            let w:name = split(w:info, '\n')
            sleep 2
            redraw!
        elseif a:verb == "Prev"
            let w:info = system('cmus-remote --prev -Q')
            let w:name = split(w:info, '\n')
            echo w:name[6][10:] '-' w:name[4][10:]
            sleep 2
            redraw!
        elseif a:verb == "Current"
            let w:info = system('cmus-remote -Q')
            let w:name = split(w:info, '\n')
            echo w:name[6][10:] '-' w:name[4][10:]
            sleep 2
            redraw!
        elseif a:verb == "Shuffle"
            let w:info = system('cmus-remote --shuffle')
           " / todo: know which state is change /
            let w:info = 'Shuffle toggled :)'
            echo w:info
            sleep 2
            redraw!
        elseif a:verb == "Repeat"                   " toggle repeat playlist after end all songs
           let w:info = system('cmus-remote -C "toggle repeat"')
           " / todo: know which state is change /
           let w:info = 'Repeat toggled :)'
           echo w:info
           sleep 2
           redraw!
       elseif a:verb == "Autonext"                  " toggle repeat one song forever
            let w:info = system('cmus-remote -C "toggle repeat_current"')
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
