TODO List

[x] - Implement Cell scene
	[x] - Implement logic to reveal cell
	[x] - Implemenet logic to reveal adjacent cells
	[x] - Implement logic to flag cells
	[x] - Implement logic to explode mine
[x] - Implement Main scene
	[x] - Implement logic to dynamically generate the grid
	[x] - Implement logic to dynamically populate the grid
	[x] - Implement logic for safe first click
	[x] - Implement win condition
[x] - Implement Win Condition
	[x] - add check_is_game_finished function
		[x] - it should check if any mine was revealed and then throw game over
		[x] - it should check if all cells that are not mines were revealed and then throw win
	[x] - add signal mine_revealed in cell.gd
		[x] - emit this signal on reveal_cell logic
[x] - Implement Flag tracking and limitation
	[x] - add a flag counter to the main script
	[x] - create a signal "flagged"
		[x] - emit this signal on toggle flag function in cell.gd
	[x] - on the main script add a function to handle the flag count
		[x] - connect this function to the signal on the populateGrid
	[x] - the amount of flags allowed are the same amount of mines.
[x] - Implement the UI
	[x] - Counter with the number of flags available
	[x] - Counter for the time passed
	[x] - Add button to restart the game
		[x] - this button should be an Emoji that changes accordingly to the situation of the game
	[] - Before the game starts, display an overlay indicating actions of left click and right click
	[] - Fix centering elements, try to center it using the HContainer or something similar.
[] - Extra
	[] - When clicking on a revealed cell, indicate what are its adjacent cells
	[] - Implement difficulty levels
		[] - Add a function that checks what is selected on the UI and then define the amount of mines and grid size.
		[] - Add a Dropdown to select the difficult of the level (Easy, Medium, Hard)
	[] - Add Sound Effects
		[] - Sound for revealing the cell
		[] - Sound for flagging and unflagging
		[] - Sound for revealing a mine
		[] - Sound for revealing an empty slot
		[] - Sound for winning
		[] - Sound for losing
		[] - Add button to disable the sound on the UI
