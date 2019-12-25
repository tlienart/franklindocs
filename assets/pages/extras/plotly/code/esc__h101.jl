# This file was generated, do not modify it. # hide
#hideall
    using Markdown
    println("\`\`\`\`\`plaintext $(Markdown.htmlesc(raw""" ```julia:jdplotly
#hideall
using PlotlyJS
using Random
function jdplotly(plot, id="jdp"*randstring('a':'z',3), style="width:600px;height:350px;")
	println("""
	~~~<div id="$id" style="$style"></div>
	<script>
		var fig = JSON.parse('$plot');
		CONTAINER = document.getElementById('$id');
		Plotly.plot(CONTAINER, fig.data, fig.layout);
	</script>
	~~~""")
end
```""")) \`\`\`\`\`")