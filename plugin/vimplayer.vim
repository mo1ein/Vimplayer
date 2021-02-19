

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



" convert time to milliseconds
function! s:ToMilliseconds(H, M, S)
    return (a:H * 3600 + a:M * 60 + a:S ) * 1000
endfunction


function! AsyncMusicName(timer)
    "/ TODO: some music file has no title or ... and cause out index range"
   "if s:which_player == 'mocp'
   "    let rem = split(system('mocp -i', ' \n'))[11]
   "    let remain = s:ToMilliseconds('0', split(rem, ':')[0], split(rem, ':')[1])
   "    call CurrentMoc()
   "else
   if s:which_player != 'mocp'
       let rem = split(system('mocp -i', ' \n'))[11]
       let position = split(system('playerctl --player=' . s:which_player . ' position --format "{{ duration(position) }}"'), '\n')[0]
       let pos = s:ToMilliseconds('0', split(position, ':')[0], split(position, ':')[1])
       let length = split(system('playerctl --player=' . s:which_player . ' metadata --format "{{ duration(mpris:length) }}"'), '\n')[0]
       let len =  s:ToMilliseconds('0', split(length, ':')[0], split(length, ':')[1])
       let remain = len - pos
       call CurrentOther()
    call timer_start(remain, 'AsyncMusicName', {'Repeat':-1})
   endif
endfunction
call timer_start('0', 'AsyncMusicName', {})


function! s:control(verb)
    " if moc is running ...
    if s:which_player == 'mocp'
        if a:verb == "Play"                  " toggle play/pausemusic
            call s:PlayMoc()
        elseif a:verb == "Pnext"             " toggle play/pausemusic
            call PnextMoc()
        elseif a:verb == "Prev"              " next music info
            call PrevMoc()
        elseif a:verb == "Current"           " current music info
            call CurrentMoc()
        elseif a:verb == "Shuffle"           " toggle shuffle
            call ShuffleMoc()
        elseif a:verb == "Repeat"            " toggle repeat playlist after end all songs
            call RepeatMoc()
        elseif a:verb == "Autonext"          " toggle repeat one music forever
            call AutonextMoc()
        endif
    " if other player is running ...
    else
        if a:verb == "Play"                  " toggle play/pausemusic
            call s:PlayOther()
        elseif a:verb == "Pnext"             " next music info
            call PnextOther()
        elseif a:verb == "Prev"              " previous music info
            call PrevOther()
        elseif a:verb == "Current"           " current music info
            call CurrentOther()
        elseif a:verb == "Shuffle"           " toggle shuffle
            call s:ShuffleOther()
        elseif a:verb == "Repeat"            " toggle repeat playlist after end all songs
            call s:RepeatOther()
        elseif a:verb == "Autonext"          " toggle repeat one music forever
            call s:AutonextOther()
        endif
    endif
endfunction


function! s:PlayMoc()
    let w:is_playing = split(system('mocp -i', ' \n'))[1]
    if w:is_playing == 'PLAY'
        let w:name = split(system('mocp -G && mocp -i'), '\n')
        echom 'Paused : ' . w:name[2][7:]
    else
        let w:name = split(system('mocp -G && mocp -i'), '\n')
        echom 'Playing : ' . w:name[2][7:]
    endif
endfunction


function! PnextMoc()
    let w:name = split(system('mocp -f && sleep 0.2 && mocp -i'), '\n')
    echom 'Playing : ' . w:name[2][7:]
endfunction


function! PrevMoc()
    let w:name = split(system('mocp -r && sleep 0.2 && mocp -i'), '\n')
    echom 'Playing : ' . w:name[2][7:]
endfunction


function! CurrentMoc()
    let w:name = split(system('mocp -i'), '\n')
    echom 'Now playing : ' . w:name[2][7:]
endfunction


function! ShuffleMoc()
    let w:info = system('mocp -t shuffle')
    echom 'Shuffle toggled :)'
endfunction


function! RepeatMoc()
    let w:info = system('mocp -t repeat')
    echom 'Repeat toggled :)'
endfunction


function! AutonextMoc()
    let w:info = system('mocp -t n')
    echom 'Autonext toggled :)'
endfunction


function! s:PlayOther()
    let w:is_playing = split(system('playerctl --player=' . s:which_player . ' status', ' \n'))[0]
    if w:is_playing == 'Playing'
        let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Paused: {{ title }}"'), '\n')[0]
        echom w:info
    else
        let w:info = split(system('playerctl --player=' . s:which_player . ' play-pause && playerctl --player=' . s:which_player . ' metadata --format "Playing: {{ title }}"'), '\n')[0]
        echom w:info
    endif
endfunction


function! PnextOther()
    let w:info = split(system('playerctl --player=' . s:which_player . ' next && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
    echo w:info
endfunction


function! PrevOther()
    let w:info = split(system('playerctl --player=' . s:which_player . ' previous && playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
    echo w:info
endfunction


function! CurrentOther()
    let w:info = split(system('playerctl --player=' . s:which_player . ' metadata --format "Now playing: {{ title }}"'), '\n')[0]
    echom w:info
endfunction


function! s:ShuffleOther()
    let w:is_shuffle = split(system('playerctl --player=' . s:which_player . ' shuffle'), '\n')[0]
    if w:is_shuffle == 'Off'
        let w:info = system('playerctl --player=' . s:which_player . ' shuffle on')
        echom 'Shuffle on'
    else
        let w:info = system('playerctl --player=' . s:which_player . ' shuffle off')
        echom 'Shuffle off'
    endif
endfunction


function! s:RepeatOther()
    let w:is_repeat = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')[0]
    if w:is_repeat == 'Playlist'
        let w:info = system('playerctl --player=' . s:which_player . ' loop none')
        echom 'Repeat Off'
    else
        let w:info = system('playerctl --player=' . s:which_player . ' loop playlist')
        echom 'Repeat On'
    endif
endfunction


function! s:AutonextOther()
    let w:is_autonext = split(system('playerctl --player=' . s:which_player . ' loop'), '\n')[0]
    if w:is_autonext == 'Track'
        let w:info = system('playerctl --player=' . s:which_player . ' loop none')
        echom 'Autonext On'
    else
        let w:info = system('playerctl --player=' . s:which_player . ' loop Track')
        echom 'Autonext Off'
    endif
endfunction


"command! player         call s:control()
command! Pp         call s:control("Play")          " Toggle play/pause
command! Pnext      call s:control("Pnext")         " Next music
command! Prev       call s:control("Prev")          " Previous music
command! Current    call s:control("Current")       " Current music info
command! Repeat     call s:control("Repeat")        " Toggle repeat
command! Shuffle    call s:control("Shuffle")       " Toggle shuffle
command! Autonext   call s:control("Autonext")      " Toggel autonext
