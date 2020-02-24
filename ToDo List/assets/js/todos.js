//check off todos by clicking
$('ul').on('click','li', function(){
	$(this).toggleClass('completed')
});

//click on x to remove todo
$('ul').on('click','span',function(e){
	$(this).parent().fadeOut(500,function(){
		$(this).remove();
	});
	e.stopPropagation();
})


//create a new todo
$("input[type='text']").keypress(function(e){
	if(e.which === 13){
		var todoText = $(this).val();
		$(this).val('');
		$('ul').append('<li><span><i class="fas fa-trash"></i></span>' + todoText + '</li>')
	}
})

//toggle form
$('.fa-plus').click(function(){
	$("input[type='text']").slideToggle();
});