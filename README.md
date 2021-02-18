# Vimplayer
- [Watch how it works](https://youtu.be/jPfP5h8UKxA)
## Control your players with vim
Supports many cool players like [Spotify](https://www.spotify.com/us/), [vlc](https://www.videolan.org/vlc/index.html), [Moc](https://github.com/jonsafari/mocp), [cmus](https://github.com/cmus/cmus), [mpv](https://mpv.io/), [RhythmBox](https://github.com/GNOME/rhythmbox), [mpd](https://www.musicpd.org/), web browsers and others :wink:

## Installation
First of all install [Playerctl](https://github.com/altdesktop/playerctl) and <br>
If you use [vim-plug](https://github.com/junegunn/vim-plug), add this line to your ```~/.vimrc``` :
```
Plug 'mo1ein/Vimplayer'
```
Then run inside Vim:
```
:so ~/.vimrc
:PlugInstall
```
If you use [Vundle](https://github.com/VundleVim/Vundle.vim), add this line to your ```~/.vimrc``` :
```
Plugin 'mo1ein/Vimplayer'
```
Then run inside Vim:
```
:so ~/.vimrc
:PluginInstall
```
## Usage
```:Pp```         Toggle  play/pause       <br>
```:Pnext```      Next music               <br>
```:Prev```       Previous music           <br>
```:Current```    Current music info       <br>
```:Repeat```     Toggle repeat            <br>
```:Shuffle```    Toggle shuffle           <br>
```:Autonext```   Toggle autonext          <br>
## Options
### Default Player
For set your Default player add this line to your `~/.vimrc`:
```
let g:default_player = 'Your player'
```
If you not set, the dafault is vlc.
### Shortcut Keys
For shortcut keys add these lines to your `~/.vimrc`:
```
" Ctrl + p  Toggle  play/pause
nnoremap <C-p> :Pp<CR>

" Ctrl + l  Next music
nnoremap <C-l> :Pnext<CR>

" Ctrl + k  Previous music
nnoremap <C-k> :Prev<CR>

" Ctrl + i  Current music info
nnoremap <C-i> :Current<CR>

" Ctrl + x  Toggle repeat
nnoremap <C-x> :Repeat<CR>

" Ctrl + s  Toggle shuffle
nnoremap <C-s> :Shuffle<CR>

" Ctrl + a  Toggle autonext
nnoremap <C-a> :Autonext<CR>
```
