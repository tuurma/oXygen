function handleClick(checkbox, pb) {
	if (checkbox.checked)
	{	
		if (pb == 'msPb')
		{
			$('.'+pb+'').css('display', 'inline');
		} 
		
		else {
			$('.'+pb+'').css('display', 'block');
			$('.'+pb+'').css('position', 'absolute');
			$('.'+pb+'').css('left', '1em');
			$('.'+pb+'').css('border-style', 'solid');
			$('.'+pb+'').css('border-bottom', 'none');
			$('.'+pb+'').css('border-left', 'none');
			$('.'+pb+'').css('border-right', 'none');
			$('.'+pb+'').css('border-top-width', 'thin');
			$('.'+pb+'').css('width', '65%');
		}

	} else {
		if (pb == 'msPb')
		{
		$('.'+pb+'').css('display', 'none');
		}
		else {
			$('.'+pb+'').css('display', 'none');
			$('.'+pb+'').css('position', '');
			$('.'+pb+'').css('left', '');
			$('.'+pb+'').css('border-style', '');
			$('.'+pb+'').css('border-bottom', '');
			$('.'+pb+'').css('border-left', '');
			$('.'+pb+'').css('border-right', '');
			$('.'+pb+'').css('border-top-width', '');
			$('.'+pb+'').css('width', '');
		}

	}
}



function showDoubles(checkbox) {

	if (checkbox.checked)
	{
		var doubles = document.getElementsByClassName('doubles');
		for (var y = 0; y < doubles.length; y++)
		{
			for (var z = 0; z < doubles[y].childNodes.length; z++) {
			    if (doubles[y].childNodes[z].className == "call") {
					doubles[y].childNodes[z].className += " doubles";
					break;
				}        
			}
		}

		checkbox.parentNode.style["background"] = '#ff0000';
		$('.doubles .readings').css('background', '#ff0000');
		$('.doubles .simpleLem').css('background', '#ff0000');
		$('.doubles .highlightLem').css('background', '#ff0000');
		$('.doubles .call').css('background', '#ff0000');
		$('.doubles').css('z-index', '200');
	} else {
		checkbox.parentNode.style["background"] = '#ffffff';
		$('.doubles .readings').css('background', '#ffffff');
		$('.doubles .simpleLem').css('background', '#ffffff');
		$('.doubles .highlightLem').css('background', '#ffffff');
		$('.doubles .call').css('background', '#ffffff');
		$('.doubles').css('z-index', '-1');
	}

}

function handleClickAppCheck(checkbox) {
	if (checkbox.checked)
	{	
		
// clear other options
	var otherWitIncomplete;
	var otherOptions = document.getElementById('menu1Options').getElementsByTagName('span')
	for (var h = 0; h < otherOptions.length; h++) {
		
			if(otherOptions[h].getElementsByTagName('input')[0].checked) 
				{	
					otherOptions[h].getElementsByTagName('input')[0].checked = false;
					// I DID try calling the function, but produced an erratic behaviour
					otherWitIncomplete = 'incomplete_' + otherOptions[h].getElementsByTagName('input')[0].value.replace(/\./g, "_");
					otherOptions[h].style["background"] = 'white';
					$('.'+ otherWitIncomplete + ' .readings').css('background', '');
					$('.'+ otherWitIncomplete + ' .simpleLem').css('background', '');
					$('.'+ otherWitIncomplete + ' .highlightLem').css('background', '');
					$('.' + otherWitIncomplete).css('z-index', '-1');
					var elemsRemove = document.getElementsByClassName(otherWitIncomplete),
					k = elemsRemove.length;
					while(k--) {
					elemsRemove[k].classList.remove(otherWitIncomplete);
					}
				}
	}
//
			var incomplete = document.getElementsByClassName('incomplete');
			for (var y = 0; y < incomplete.length; y++)
			{
				for (var z = 0; z < incomplete[y].childNodes.length; z++) {
				    if (incomplete[y].childNodes[z].className == "call") {
						incomplete[y].childNodes[z].className += " incomplete";
						break;
					}        
				}
			}


		checkbox.parentNode.style["background"] = '#ff0000';
		$('.incomplete .readings').css('background', '#ff0000');
		$('.incomplete .simpleLem').css('background', '#ff0000');
		$('.incomplete .highlightLem').css('background', '#ff0000');
		$('.incomplete .call').css('background', '#ff0000');
		$('.incomplete').css('z-index', '200');
	} else {
		checkbox.parentNode.style["background"] = '#ffffff';
		$('.incomplete .readings').css('background', '#ffffff');
		$('.incomplete .simpleLem').css('background', '#ffffff');
		$('.incomplete .highlightLem').css('background', '#ffffff');
		$('.incomplete .call').css('background', '#ffffff');
		$('.incomplete').css('z-index', '-1');
	}
}

function isInArray(value, array) {
  return array.indexOf(value) > -1;
}



function chooseColor(rank) {
// arguments: rank of the witness

var colors = ["#FFE4C4", "#FF7F50", "#00FFFF", "#FF00FF", "#32CD32", "#D2691E", "#7FFF00", "#FF1493", "#9932CC", "#FFB6C1", "#D2B48C", 
"#00FFFF", "#E9967A", "#DAA520", "#BC8F8F", "#4169E1", "#2E8B57", "#FFD700", "#6495ED", "#006400"];

if (rank > colors.length)
	{
		// the rank of the current witness is over the number of different colors; 
		while (rank > colors.length)
		{
			rank = rank % colors.length;
		}			
	}
	
	return colors[rank-1];
}




function handleClickAppCheckSingle(checkbox, wit, rank) {

	// replace dots in wit name with _, because a dot in the class name would mess up the css
	var witIncomplete = 'incomplete_' + wit.replace(/\./g, "_");
	if (wit == '')
	{
		witIncomplete = 'incomplete_noWitnessAtAll';
	}


	if (checkbox.checked)
	{		



	// we uncheck the "All" option
	if (document.getElementById('menu1AllChk').checked)
	{
		// un-highlight All
		document.getElementById('menu1AllChk').checked = false;
		document.getElementById('menu1All').style["background"] = '#ffffff';
		$('.incomplete .readings').css('background', '#ffffff');
		$('.incomplete .simpleLem').css('background', '#ffffff');
		$('.incomplete .highlightLem').css('background', '#ffffff');
		$('.incomplete').css('z-index', '-1');
	}
	
//
// Let us clear all other possibly checked options
//
	var localWit = checkbox.value;
	var otherWitIncomplete;

	var otherOptions = document.getElementById('menu1Options').getElementsByTagName('span')
	for (var h = 0; h < otherOptions.length; h++) {
		if (otherOptions[h].getElementsByTagName('input')[0].value != localWit)
		{
			if(otherOptions[h].getElementsByTagName('input')[0].checked) 
				{	
					otherOptions[h].getElementsByTagName('input')[0].checked = false;
					// I DID try calling the function, but produced an erratic behaviour
					otherWitIncomplete = 'incomplete_' + otherOptions[h].getElementsByTagName('input')[0].value.replace(/\./g, "_");
					otherOptions[h].style["background"] = 'white';
					$('.'+ otherWitIncomplete + ' .readings').css('background', '');
					$('.'+ otherWitIncomplete + ' .simpleLem').css('background', '');
					$('.'+ otherWitIncomplete + ' .highlightLem').css('background', '');
					$('.' + otherWitIncomplete).css('z-index', '-1');
					var elemsRemove = document.getElementsByClassName(otherWitIncomplete),
					k = elemsRemove.length;
					while(k--) {
					elemsRemove[k].classList.remove(otherWitIncomplete);
					}
				}
		}
	}

	// Let us also clear the options in menu 2
	var otherOptions2 = document.getElementById('menu2Options').getElementsByTagName('span')
	for (var g = 0; g < otherOptions2.length; g++) {
			if(otherOptions2[g].getElementsByTagName('input')[0].checked) 
				{	
					otherOptions2[g].getElementsByTagName('input')[0].checked = false;
					handleClickAppCheckPresence(otherOptions2[g].getElementsByTagName('input')[0], otherOptions2[g].getElementsByTagName('input')[0].value, 1);
				}
	}




	// let us select all the apps belonging to the "incomplete" class; by definition, 
	// an app missing a single witness is incomplete, no need to check the full apps.
	var incomplete = document.getElementsByClassName('incomplete'),
		i = incomplete.length;

// special case: looking for apps with no witness indication at all
	
		while(i--) {
		// see if @title of the current app lists contains the desired witness 
		
		
		if (wit == '')
		{
			if (incomplete[i].title == wit)
			{	
				incomplete[i].className += " " + witIncomplete;
			}
		}
		else {
			var array = incomplete[i].title.split("|");		
			if (isInArray(wit, array))
			{
			} else {
			// do something fancy
	        incomplete[i].className += " " + witIncomplete;
			for (var z = 0; z < incomplete[i].childNodes.length; z++) {
			    if (incomplete[i].childNodes[z].className == "call") {
					incomplete[i].childNodes[z].className += " " + witIncomplete;
					break;
				}        
			}

			}
		}
		
		}

		// now that we have added a custom class to each faulty app, highlight them
		var color = chooseColor(rank);
		if(wit == '') {color = 'red';}
		$('.'+ witIncomplete + ' .readings').css('background', color);
		$('.'+ witIncomplete + ' .simpleLem').css('background', color);
		$('.'+ witIncomplete + ' .highlightLem').css('background', color);
		$('.'+ witIncomplete + ' .call').css('background', color);
		$('.' + witIncomplete).css('z-index', '200');

		// highlight the witness in the toolbox for better readability
		checkbox.parentNode.style["background"] = color;
	} 
		
	else {
		checkbox.parentNode.style["background"] = 'white';
		$('.'+ witIncomplete + ' .readings').css('background', '');
		$('.'+ witIncomplete + ' .simpleLem').css('background', '');
		$('.'+ witIncomplete + ' .highlightLem').css('background', '');
		$('.'+ witIncomplete + ' .call').css('background', '');
		$('.' + witIncomplete).css('z-index', '-1');
		var elems = document.getElementsByClassName(witIncomplete),
		j = elems.length;
		while(j--) {
			elems[j].classList.remove(witIncomplete);
		}
	}
}


function handleClickAppCheckPresence(checkbox, wit, rank) {

	// replace dots in wit name with _, because a dot in the class name would mess up the css
	var witPresent = 'present_' + wit.replace(/\./g, "_");


	if (checkbox.checked)
	{		




//
// Let us clear all other possibly checked options
//
	var localWit = checkbox.value;
	var otherWitIncomplete;

	var otherOptions = document.getElementById('menu2Options').getElementsByTagName('span');
	for (var h = 0; h < otherOptions.length; h++) {
		if (otherOptions[h].getElementsByTagName('input')[0].value != localWit)
		{
			if(otherOptions[h].getElementsByTagName('input')[0].checked) 
				{	
					otherOptions[h].getElementsByTagName('input')[0].checked = false;
					otherWitIncomplete = 'present_' + otherOptions[h].getElementsByTagName('input')[0].value.replace(/\./g, "_");
					otherOptions[h].style["background"] = 'white';
					$('.'+ otherWitIncomplete + ' .readings').css('background', '#ffffff');
					$('.'+ otherWitIncomplete + ' .simpleLem').css('background', '#ffffff');
					$('.'+ otherWitIncomplete + ' .highlightLem').css('background', '#ffffff');
					$('.' + otherWitIncomplete).css('z-index', '-1');
					var elemsRemove = document.getElementsByClassName(otherWitIncomplete),
					k = elemsRemove.length;
					while(k--) {
					elemsRemove[k].classList.remove(otherWitIncomplete);
					}
				}
		}
	}
// Also clear options from the previous menu
	// we uncheck the "All" option
	if (document.getElementById('menu1AllChk').checked)
	{
		// un-highlight All
		document.getElementById('menu1AllChk').checked = false;
		document.getElementById('menu1All').style["background"] = '#ffffff';
		$('.incomplete .readings').css('background', '#ffffff');
		$('.incomplete .simpleLem').css('background', '#ffffff');
		$('.incomplete .highlightLem').css('background', '#ffffff');
		$('.incomplete').css('z-index', '-1');
	}
	// we uncheck the other options in menu 1
	var otherOptions2 = document.getElementById('menu1Options').getElementsByTagName('span')
	for (var g = 0; g < otherOptions.length; g++) {
			if(otherOptions2[g].getElementsByTagName('input')[0].checked) 
				{	
					otherOptions2[g].getElementsByTagName('input')[0].checked = false;
					handleClickAppCheckSingle(otherOptions2[g].getElementsByTagName('input')[0], otherOptions2[g].getElementsByTagName('input')[0].value, 1);
				}
	}


	// let us select all the apps belonging to the "incomplete" class; by definition, 
	// an app missing a single witness is incomplete, no need to check the full apps.
	var app = document.getElementsByClassName('app'),
		i = app.length;


    while(i--) {
		// see if @title of the current app lists contains the desired witness 
		var array = app[i].title.split("|");
		if (isInArray(wit, array))
		{
			// do something fancy
	        app[i].className += " " + witPresent;
			
			for (var z = 0; z < app[i].childNodes.length; z++) {
			    if (app[i].childNodes[z].className == "call") {
					app[i].childNodes[z].className += " " + witPresent;
					break;
				}        
			}
			
		} else {
		}
    }

		// now that we have added a custom class to each faulty app, highlight them
		var color = chooseColor(rank);
		$('.'+ witPresent + ' .readings').css('background', color);
		$('.'+ witPresent + ' .simpleLem').css('background', color);
		$('.'+ witPresent + ' .highlightLem').css('background', color);
		$('.'+ witPresent + ' .call').css('background', color);
		$('.' + witPresent).css('z-index', '200');
		// highlight the witness in the toolbox for better readability
		checkbox.parentNode.style["background"] = color;


	} else {
		// we have to apply the previous css settings... 
		checkbox.parentNode.style["background"] = 'white';
		$('.'+ witPresent + ' .readings').css('background', '#ffffff');
		$('.'+ witPresent + ' .simpleLem').css('background', '#ffffff');
		$('.'+ witPresent + ' .highlightLem').css('background', '#ffffff');
		$('.'+ witPresent + ' .call').css('background', '#ffffff');
		$('.' + witPresent).css('z-index', '-1');
		// ... before removing the custom class from the elements
		var elems = document.getElementsByClassName(witPresent),
		j = elems.length;
		while(j--) {
			elems[j].classList.remove(witPresent);
		}
	}


}






function showAppType(checkbox, type) {

if (checkbox.checked)
{
	if (type == 'lem')
	{

			var elems = document.getElementsByClassName('simpleLem'),
			j = elems.length;
			while(j--) {
				elems[j].className += " simpleLemHighlight";
				//added the following for lems with only an addition in rdg, where only the footnote call appears
				elems[j].parentNode.getElementsByTagName('span')[1].className += " simpleLemHighlight";
			}
			$('.' + witPresent).css('z-index', '200');
			checkbox.parentNode.className += " simpleLemHighlight";			
	} else {

				var elems = document.getElementsByClassName('readings'),
		j = elems.length;
		while(j--) {
			elems[j].className += " readingsHighlight";
		}
			$('.' + witPresent).css('z-index', '200');
			checkbox.parentNode.className += " readingsHighlight";
	}

} else {
	if (type == 'lem')
	{
			var elems = document.getElementsByClassName('simpleLemHighlight'),
			j = elems.length;
			while(j--) {
				elems[j].classList.remove('simpleLemHighlight');
			}
				$('.' + witPresent).css('z-index', '-1');
	} else {
			var elems = document.getElementsByClassName('readingsHighlight'),
			j = elems.length;
			while(j--) {
				elems[j].classList.remove('readingsHighlight');
			}
			$('.' + witPresent).css('z-index', '-1');
	}
}


}



