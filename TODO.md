[x] revisit MatchUser ... really necessary?
[x] refactor ask_for_cards on Match
[x] add player id to MatchPerspective and put in data attribute on page
[x] remove Book.full?
[x] combine controllers related to matches
[x] add Devise
[ ] fix the magic strings related to events (see Match.ask_for_cards)
[ ] remove pending? and started? from MatchPerspective (no need for them anymore)
[ ] rename current_player on Match to current_user (no AR issue, what about Devise?)
[ ] add name validation to User
[ ] make MatchController return JSON
[ ] account for ties in the game
