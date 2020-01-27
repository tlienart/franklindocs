# This file was generated, do not modify it. # hide
#hideall
    using Markdown
    println("\`\`\`\`\`plaintext $(Markdown.htmlesc(raw""" \newcommand{\card}[4]{
    @@card
      ![#1](/assets/pages/code/img/postcard.jpg)
      @@container
        ~~~
        <h2>#1</h2>
        ~~~
        @@title #2 @@
        @@vitae #3 @@
        @@email #4 @@
        ~~~
        <p><button class="button">Contact</button></p>
        ~~~
      @@
    @@
  }""")) \`\`\`\`\`")