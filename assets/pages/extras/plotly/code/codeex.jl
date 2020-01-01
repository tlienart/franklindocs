# This file was generated, do not modify it. # hide
#hideall
import PlotlyJS, Random

function jdplotly(plt, id="jdp"*Random.randstring('a':'z', 3),
	 	  	  style="width:600px;height:350px;")
	println("""
	~~~
	&lt;div id&#61;&quot;&#36;id&quot; style&#61;&quot;&#36;style&quot;&gt;&lt;/div&gt;
	&lt;script&gt;
		var fig &#61; JSON.parse&#40;&#39;&#36;&#40;PlotlyJS.json&#40;plt&#41;&#41;&#39;&#41;;
		CONTAINER &#61; document.getElementById&#40;&#39;&#36;id&#39;&#41;;
		Plotly.plot&#40;CONTAINER, fig.data, fig.layout&#41;;
	&lt;/script&gt;
	~~~""")
end