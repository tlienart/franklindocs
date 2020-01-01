# This file was generated, do not modify it. # hide
#hideall
import PlotlyJS, Random

function jdplotly(plt, id="jdp"*Random.randstring('a':'z', 3),
	 	  	  style="width:600px;height:350px;")
	println("""
	~~~
	<div id="$id" style="$style"></div>
	<script>
        var fig = JSON.parse('$(PlotlyJS.json(plt))');
        CONTAINER = document.getElementById('$id');
        Plotly.plot(CONTAINER, fig.data, fig.layout);
	</script>
	~~~""")
end