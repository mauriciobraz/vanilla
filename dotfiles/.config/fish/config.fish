if status --is-interactive
   if not functions -q fisher
       curl -sL https://git.io/fisher | fish
       fisher update
   end
end
