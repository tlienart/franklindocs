# This file was generated, do not modify it. # hide
#hideall
    using Markdown
    println("\`\`\`\`\`html $(Markdown.htmlesc(raw""" ~~~
<div id="tester" style="width:600px;height:350px;"></div>

<script>
	TESTER = document.getElementById('tester');
	Plotly.plot( TESTER, [{
	x: [1, 2, 3, 4, 5],
	y: [1, 2, 4, 8, 16] }], {
	margin: { t: 0 } } );
</script>
~~~""")) \`\`\`\`\`")