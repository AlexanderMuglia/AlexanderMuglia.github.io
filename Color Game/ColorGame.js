var numSquares = 6;
var colours = [];
var pickedColor;
var squares = document.querySelectorAll(".square");
var colorDisplay = document.getElementById('colorDisplay');
var message = document.getElementById("message");
var h1s = document.querySelector("h1");
var resetButton = document.getElementById("reset");
var modeButtons = document.querySelectorAll(".mode");

init();

resetButton.addEventListener("click", function(){
	reset();
})

function init(){
	//mode button event listeners
	modeButtonSetup();
	//set up the page style wise
	reset();
	//square event listeners 
	squareSetup();
}

function changeColors(color){
	//loop through all squares
	for(i = 0; i<squares.length; i++){
		//change each color to match given color
		squares[i].style["background-color"] = color;
		h1s.style["background-color"] = color;
	}
}

function pickColor(){
	var random = Math.floor(Math.random() * colours.length);
	return colours[random];
}

function generateRandomColors(num){
	//make array
	var arr = [];
	//add num random colors to array
	for(i = 0; i < num; i++){
		//get random color, put it in array
		arr[i] = randomColor();
	}
	//return array
	return arr;
}

function modeButtonSetup(){
	for (var i = 0; i < modeButtons.length; i++) {
	 modeButtons[i].addEventListener("click", function(){
	 	modeButtons[0].classList.remove("selected");
	 	modeButtons[1].classList.remove("selected");
	 	this.classList.add("selected");
	 	this.textContent === "Easy" ? numSquares = 3: numSquares = 6;
	 	reset();
 		})
	}
}

function squareSetup(){
	for(i = 0; i<colours.length; i++){
		//add click listeners to the squares
		squares[i].addEventListener("click", function(){
			//get color of clicked square
			var clickedColor = this.style['background-color'];
			//compare color to pickedColor
			if(clickedColor === pickedColor){
				message.textContent = "Correct!";
				changeColors(pickedColor);
				resetButton.textContent = "Play Again";
			}else{
				this.style["background-color"] = "#232323";
				message.textContent = "Try Again";
				resetButton.textContent = "Reset";
			}
		});
	}
}

function reset(){
	//get new colors
	colours = generateRandomColors(numSquares);
	//pick new color from array
	pickedColor = pickColor();
	//change colorDisplay to match
	colorDisplay.textContent = pickedColor;
	//change square colors
	for(i = 0; i < squares.length; i++){
		if(colours[i]){
			squares[i].style.display = "block";
			squares[i].style["background-color"] = colours[i];
		}else{
			squares[i].style.display = "none";
		}
	
	}
	h1s.style["background-color"] = "steelblue"
	resetButton.textContent = "New Colours"
	message.textContent = "";
}

function randomColor(){
	//pick rgb from 0 to 255
	var r = Math.floor(Math.random() * 256);
	var g = Math.floor(Math.random() * 256);
	var b = Math.floor(Math.random() * 256);
	return "rgb(" + r +", "+g +", " + b + ")"
}