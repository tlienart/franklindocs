# This file was generated, do not modify it. # hide
#hideall
    using Markdown
    println("\`\`\`\`\`html $(Markdown.htmlesc(raw""" ```julia:fdplotly
#hideall
using PlotlyJS, Random

function fdplotly(plt, id="fdp"*randstring('a':'z', 3),
	 			  style="width:600px;height:350px")
    println("""
		~~~
		<div id="$id" style="$style"></div>

		<script>
			var fig = $(json(plt));
			CONTAINER = document.getElementById('$id');
			Plotly.newPlot(CONTAINER, fig.data, fig.layout)
		</script>
		~~~
		""")
end
```""")) \`\`\`\`\`")