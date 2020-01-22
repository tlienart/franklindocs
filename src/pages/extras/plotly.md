@def hascode = true
@def hasplotly = true

# Work with Plotly

If you want interactive plots on some pages and are not afraid of using heavy javascript libraries, then [Plotly](https://plot.ly/javascript/) is a nice library.
The Julia wrapper [PlotlyJS.jl](https://github.com/sglyon/PlotlyJS.jl) can be used to generate Plotly plots.

## Pre-requisites

Download [`plotly.min.js`](https://cdn.plot.ly/plotly-latest.min.js) saving it to `/libs/plotly/plotly.min.js`.

Then create a variable `hasplotly` with default value `false`: in your `config.md` write

```
@def hasplotly = false
```

Finally, in your `src/_html_parts/head.html` add

\esc{h00}{
{{if hasplotly}} <script src="/libs/plotly/plotly.min.js"></script> {{end}}
}

## Offline-generated plot

Assuming you already have the Plotly code for some plot, displaying  the  result on a page with Franklin is now pretty straightforward.
Start by adding

```
@def hasplotly = true
```

so that the JS library  will be  loaded then somewhere appropriate add:

\esch{h0}{
~~~
<div id="tester" style="width:600px;height:350px;"></div>

<script>
	TESTER = document.getElementById('tester');
	Plotly.plot( TESTER, [{
	x: [1, 2, 3, 4, 5],
	y: [1, 2, 4, 8, 16] }], {
	margin: { t: 0 } } );
</script>
~~~
}

This will give:

~~~
<div id="tester" style="width:600px;height:350px;"></div>

<script>
	TESTER = document.getElementById('tester');
	Plotly.plot( TESTER, [{
	x: [1, 2, 3, 4, 5],
	y: [1, 2, 4, 8, 16] }], {
	margin: { t: 0 } } );
</script>
~~~

## Live-generated plot

One step further is to use `PlotlyJS` to define a  plot then pass the result to  Franklin.
Start by adding `PlotlyJS` and `Random` to your environment:

```julia-repl
(myWebsite) pkg> add PlotlyJS Random
```

Then, beyond the `@def hasplotly = true`, add the following code in an evaluated Julia code block:

```julia
#hideall
import PlotlyJS, Random

function fdplotly(plt, id="fdp"*Random.randstring('a':'z', 3),
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
```

```julia:plotlycode
#hideall
import PlotlyJS, Random

function fdplotly(plt, id="fdp"*Random.randstring('a':'z', 3),
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
```

It defines a function that prints Markdown very similar to what we used earlier to display a Plotly plot.

You can now use `PlotlyJS` to define a plot and use `fdplotly` to display it on your page.
The following code:

`````
```julia:ex1
z =  [10     10.625  12.5  15.625  20
     5.625  6.25    8.125 11.25   15.625
     2.5    3.125   5.    8.125   12.5
     0.625  1.25    3.125 6.25    10.625
     0      0.625   2.5   5.625   10]

data   = PlotlyJS.contour(; z=z)
layout = PlotlyJS.Layout(; title="Basic Contour Plot")
plt    = PlotlyJS.plot(data, layout)

fdplotly(plt) # hide
```
\textoutput{ex1}
`````

gives:

```julia:ex1
z =  [10     10.625  12.5  15.625  20
     5.625  6.25    8.125 11.25   15.625
     2.5    3.125   5.    8.125   12.5
     0.625  1.25    3.125 6.25    10.625
     0      0.625   2.5   5.625   10]

data   = PlotlyJS.contour(; z=z)
layout = PlotlyJS.Layout(; title="Basic Contour Plot")
plt    = PlotlyJS.plot(data, layout)

fdplotly(plt) # hide
```
\textoutput{ex1}
