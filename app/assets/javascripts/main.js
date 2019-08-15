$(function(){
	if($("#index-container").length){
  let magicGrid = new MagicGrid({
	container: '#index-container',
	animate: true,
	gutter: 30,
	static: true,
	useMin: true
});
magicGrid.listen();
		};
});
