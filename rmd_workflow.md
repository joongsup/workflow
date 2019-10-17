

---
title: "R Markdown Centered Data Analysis Workflow Using Vim"
subtitle: "(bonus: how to use Python in R Markdown using reticulate)"
date: "2019-10-16 (updated 2019-10-17)"
output:
  html_document:
    toc: true
    toc_float: false
    number_sections: true
    theme: united
    highlight: textmate
    code_folding: show
    code_download: true
    keep_md: true
---

# Introduction

This document describes a data analysis project workflow that uses an R Markdown as a summary (home?) document in which codes written in R and Python are run and findings/narratives follow immediately after each code execution. For general information on R Markdown, see [here](https://rmarkdown.rstudio.com/). For syntax, see [cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf).

R Markdown can be used to generate a (portable) document that includes,

- Codes: not just of R, but also other languages as well (e.g., Python)
- Tables/plots: output from source codes
- Narratives/findings: narratives documenting quick findings

Therefore, I think it's a great way to document progress/findings of a data analysis project. (NOTE: maybe add pros and cons of using Rmd vs. Jupyter Notebook)

# Pre-requisites 

- Need to have [pandoc](https://pandoc.org) installed. 
- Need to have several latest R packages installed: e.g., rmarkdown, reticulate (to use Python)

# Examples

For both R and Python, this document will show examples of working with

- small code snippets embedded within Rmd document
- import/source functions defined in separate scripts then use them within Rmd document
- execute/source separate script files to show outputs from corresponding scripts

In this workflow, I find it helpful to have at least 3 different vim/REPL paired sessions open:

- vim/Rmd for the source .Rmd editing and an interactive R session (let's call it session "Rmd")
- vim/R for .R script file editing and an interactive R session  (let's call it session "R")
- vim/Py for .py script file editing and an interactive Python session (let's call it session "Python")

## Working with R codes


```r
# R set up (later, there is a separate python set up chunk)

library(ggplot2)
library(dplyr)
library(uncmbb)
library(reticulate) # for Python

# need to specify Python location if planning to use python
# note use_python is an R function, so need to be used in R chunk, not the python one
use_python(python3_path) # python3_path is defined in my .Rprofile
```

### Running R code snippets within Rmd document 

We can run simple R code snippets like below.


```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
plot(iris)
```

![](rmd_workflow_files/figure-html/r_snippet_1-1.png)<!-- -->

- Note that 'print' command was not needed to actually print output of the head and plot commands

When some R packages are needed, best practice is to load them in setup chunk, generally found in the beginning of the Rmd document.


```r
# Using public and personal R packages: load them in setup chunk in the beginning

df <- rbind(unc %>% mutate(school = "UNC"), duke %>% mutate(school = "Duke"))
df <- df %>% dplyr::filter(Type == "NCAA") %>%
             count(school, Result)
head(df)
```

```
## # A tibble: 4 x 3
##   school Result     n
##   <chr>  <chr>  <int>
## 1 Duke   L         37
## 2 Duke   W        111
## 3 UNC    L         43
## 4 UNC    W        122
```

```r
df %>%  ggplot(aes(x = Result, y = n)) +
        geom_bar(aes(fill = school), stat = "identity", position = "dodge") +
        geom_text(aes(group = school, label = n), position = position_dodge(width = 1), vjust = 0.01) +
        labs(title = "UNC and Duke's NCAA results since 1949-1950 season") +
        theme_bw()
```

![](rmd_workflow_files/figure-html/r_snippet_2-1.png)<!-- -->

- Again, output from 'head' and 'ggplot' commands were displayed without manual printing

Objects from above R code snippets can be accessed/used throughout this Rmd document, typically when describing the findings from the snippet. E.g., below findings are calculated inline using objects from above chunk. 

Since 1949-1950 season, 

- UNC has played total 165 games and won 122 games, and lost 43.
- Duke has played total 148 games and won 111 games, and lost 37.

Findings follow:

- Note again that if snippets are run within Rmd, then no manual print command is needed to print plot
- The home (Rmd) document can become clogged easily

So we've seen how we can use R code snippets in Rmd document, which can be effective for small operations. For more complex operations that require a bit more lines of codes, working directly with code snippets within Rmd document may not be ideal for various reasons. In this case, we can save those (many) lines of codes in separate script files, then source them in Rmd document. First, a hybrid of the two:

### Importing functions from R script files then use them within Rmd document

We can source .R scripts within an R chunk and use functions defined in .R scripts.


```r
# hello function from R/r_udfs.R
source("R/r_udfs.R")
hello("Jay")
```

```
## [1] "Hello, Jay! 'hello' function is defined in r_udfs.R!"
```

- This allows functions to be defined in another .R script, then used in the home (Rmd) document
- The home Rmd document can become clogged easily still

### Running R script files within Rmd document

Below, we source "src_r_script.R" file in an R chunk, which has the same commands as the r_snippet_2 chunk. While writing the src_r_script.R code, I'd made sure each line works as intended from a separate R session. This ensures

- the source script works, and
- the findings/narratives can be added to home (Rmd) document without having to render the whole Rmd document 


```r
source("R/src_r_script.R")
```

```
## # A tibble: 4 x 5
## # Groups:   school [2]
##   school Result     n grp_tot grp_perc
##   <chr>  <chr>  <int>   <int>    <dbl>
## 1 Duke   L         37     148    0.25 
## 2 Duke   W        111     148    0.75 
## 3 UNC    L         43     165    0.261
## 4 UNC    W        122     165    0.739
```

![](rmd_workflow_files/figure-html/run_r_script-1.png)<!-- -->

Findings/narratives from the above R script follow immediately, and also more importantly without having to render the whole Rmd document, as the source R script was run and output was checked in a separate session (session "R").

- Note the ggplot object at the end of the src_r_script.R had to be saved to a variable and printed manually. Without such manual print command, the plot wouldn't display in rendered Rmd document.  
- UNC won more games than Duke in NCAA tourney since 1949-50 season
- but they lost more games too

## Working with Python codes

We can also work with Python codes from within Rmd document, using [reticulate](https://rstudio.github.io/reticulate/) package!

### Running Python code snippets within Rmd document 


```python
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

x1 = ['a', 'b', 'c', 'c', 'c', 'b', 'b', 'a', 'a', 'c']
x2 = range(10)
y = [True, False, False, False, True, True, True, False, True, False]
df = pd.DataFrame(zip(x1, x2, y), columns = ['x1', 'x2', 'y'])

# View the data frame
df.head()

# View plot
```

```
##   x1  x2      y
## 0  a   0   True
## 1  b   1  False
## 2  c   2  False
## 3  c   3  False
## 4  c   4   True
```

```python
df.groupby('x1').size().reset_index(name = 'count').plot(kind = 'bar', x = 'x1', y = 'count')
plt.show()
```

![](rmd_workflow_files/figure-html/py_snippet_1-1.png)<!-- -->

Finding follows:

- A toy dataframe is hard(er) to put together in Python than in R!

We can check this Python code snippet works from a separate **Python** session. 

It's preferable to first create a setup chunk specifically for Python codes, like that for R.


```python
import os
import sys
import pickle
import numpy as np
import pandas as pd
import importlib
from matplotlib import pyplot as plt
plt.switch_backend('agg') # switch to 'agg' bakend, not X11, in order to disable interactive plot printing during rendering
```

It seems once a python chunk is called, a separate python session is created and maintained throughout the live/active source Rmd document lifetime, therefore allowing the use of imported functions in the subsequent python chunks.

### Importing functions from Python script files then use them within Rmd document


```python
# hello function from py/py_udfs.py
from py.py_udfs import * 
hello("Jay")
```

```
## Hello, Jay! 'hello' function is defined in py_udfs.py!
```

Note that we can run functions from the imported module as well, e.g., we imported all functions from py_udfs.py and used one of its functions 'hello' above.

### Running Python script files within Rmd document


```r
# note language engine here is R, not Python, although we're running Python code!
source_python("py/src_python_script.py") # without "scratch/" in filename
```

- unfortunately, using source_python() in an R chunk didn't display plots (at all) in the rendered doc (tried both agg and x11 backend)
- not sure why so


```python
# execfile seems to be the closest thing to R's source command (Python2)
exec(open("py/src_python_script.py").read())
```

```
##   x1  x2      y
## 0  a   0   True
## 1  b   1  False
## 2  c   2  False
## 3  c   3  False
## 4  c   4   True
```

![](rmd_workflow_files/figure-html/run_py_script3-1.png)<!-- -->

This worked! Since analyses are typically procedural, above approach should suffice in many cases. 

### Running Python code snippet using R objects

- Can also run python snippets from within Rmd document. 
- All required modules are imported in earlier setup_py chunk. 
- My personal preference is, if you can work with Python directly, why rely on R? (and same for using Python objects in R chunk)


```python
unc_py = r.unc # should have loaded library(uncmbb) beforehand
print(unc_py.head())
```

```
##   Season   Game_Date Game_Day Type Where    Opponent_School Result    Tm   Opp  OT
## 0   1950  1949-12-01      Thu  REG     H               Elon      W  57.0  39.0  NA
## 1   1950  1949-12-03      Sat  REG     A           Richmond      W  58.0  50.0  NA
## 2   1950  1949-12-05      Mon  REG     A      Virginia Tech      L  48.0  62.0  NA
## 3   1950  1949-12-07      Wed  REG     A       Lenoir-Rhyne      L  78.0  79.0  OT
## 4   1950  1949-12-09      Fri  REG     H  George Washington      L  44.0  54.0  NA
```

```python
unc_py.groupby('Type').size().plot(kind = 'bar')
plt.show()
```

![](rmd_workflow_files/figure-html/py_snippet_using_r_objs-1.png)<!-- -->

Findings follow:

- Data conversion between R and Python seems challenging
- Also, interactive checking becomes a bit hard

# Report output

Once all source codes are run and findings/narratives are documented, we can go ahead and generate a summary document. Whether html or pdf, I find having an intermediate summary document of a data analysis project helps me understand the progression/findings of the project more efficiently, especially after some time off the project. 

There are several options to view the output document. 

1. If no file transfer is required (e.g., all files are already in local machine), open the output in a browser
2. If file transfer is needed (e.g., some files are generated in remote machine), then
    - send email from R with attachment 
    - SimpleHTTPServer from Python

# R Markdown-centered data analysis workflow

1. Start three vim/REPL paired sessions
    - session Rmd: for Rmd document (call it "home" document?) editing and interactive R session
    - session R: for R script editing and interactive R session
    - sesion py: for py script editing and interactive Python session

2. Start documenting project meta data, e.g., introduction, context, etc., in the home (Rmd) document 

3. Iteratively work on codes (R/Python), generate plots, and document findings 
    - Make sure codes run successfully by checking outputs, e.g., plots from terminal (ssh -YC)
    - If findings are worth noting, document them in home (Rmd) document, following corresponding code chunks

4. Render to html document and enjoy the output!
