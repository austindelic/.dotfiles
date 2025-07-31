if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_logo \
    --description="Fish-shell colorful ASCII-art logo" \
    --argument-names outer_color medium_color inner_color mouth eye

    # defaults:
    [ $outer_color ]; or set outer_color red
    [ $medium_color ]; or set medium_color f70
    [ $inner_color ]; or set inner_color yellow
    [ $mouth ]; or set mouth '['
    [ $eye ]; or set eye O

    set usage 'Usage: fish_logo <outer_color> <medium_color> <inner_color> <mouth> <eye>
See set_color --help for more on available colors.'

    if contains -- $outer_color --help -h -help
        echo $usage
        return 0
    end

    # shortcuts:
    set o (set_color $outer_color)
    set m (set_color $medium_color)
    set i (set_color $inner_color)

    if test (count $o) != 1; or test (count $m) != 1; or test (count $i) != 1
        echo 'Invalid color argument'
        echo $usage
        return 1
    end

    echo '                 '$o'___
  ___======____='$m'-'$i'-'$m'-='$o')
/T            \_'$i'--='$m'=='$o')
'$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')
 \      / )J'$m'~~    '$o'\\'$i'-='$o')
  \\\\___/  )JJ'$m'~'$i'~~   '$o'\)
   \_____/JJJ'$m'~~'$i'~~    '$o'\\
   '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\
  (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_
  '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__
   '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\
          '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)
                      '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)
                      (J'$m'JJ'$o'| \UUU)
                       (UU)'(set_color normal)
end
function fish_greeting
    fortune | cowsay -n | lolcat
    fish_logo

end
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
starship init fish | source

function ls --description 'Use eza instead of ls'
    eza -h \
        --icons \
        --group-directories-first \
        --git \
        --header \
        --time-style=long-iso \
        $argv
end

function y --description 'Use yazi as y'
    yazi
end
function z --description 'Use zellij as z'
    zellij
end
function c --description 'Clear the screen with c'
    clear
end
alias bb 'brew bundle --global -v'
