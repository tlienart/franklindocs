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

Assuming you already have the Plotly code for some plot, displaying  the  result on a page with JuDoc is now pretty straightforward.
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

One step further is to use `PlotlyJS` to define a  plot then pass the result to  JuDoc.
Start by adding `PlotlyJS` and `Random` to your environment:

```julia-repl
(myWebsite) pkg> add PlotlyJS Random
```

Then, beyond the `@def hasplotly = true`, add the following code in an evaluated Julia code block:

```julia
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
```

```julia:plotlycode
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
```

It defines a function that prints Markdown very similar to what we used earlier to display a Plotly plot.

You can now use `PlotlyJS` to define a plot and use `jdplotly` to display it on your page.
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

jdplotly(plt) # hide
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

jdplotly(plt) # hide
```
\textoutput{ex1}
