# `carboncopy` - An RStudio Add-In for inline reporting of datestamped output

--------------------------------------------------------------------------------

It is useful to present some of a program's output together with its code, even
when we're working in plain `.R` scripts and not RMarkdown documents. We might
want to do this for a few reasons, including:

1. We can show the code to other people and demonstrate what it does without
   having to reload large datasets or execute long-running processes.
2. If we do exploratory analyses to make decisions about data cleaning and
   processing, e.g. `table()` or `fivenum()` calls, we can keep the results of
   those analyses in the code as a paper trail.
   
This RStudio Add-In automates that by inserting the last expression's output as 
a comment, along with a datestamp showing when the code was last run for 
reportability and as a code smell.

![](https://github.com/DesiQuintans/carboncopy/blob/main/readme_files/demo_gif.gif?raw=true)

--------------------------------------------------------------------------------

# Instructions

## Install it

The best way to get `carboncopy` is to install it through `addinslist`, which lets
you browse other RStudio add-ins too.

```r
install.packages("addinslist")
```

Alternatively, you can install the development version of `carboncopy` like so:

``` r
# install.packages("remotes")
remotes::install_github("DesiQuintans/carboncopy")
```

This package will not be released on CRAN.



## Access it...

### By binding to a keyboard shortcut

Bind `carboncopy`'s _Insert .Last.value as a comment_ function to a keyboard 
shortcut by going to **Tools > Modify Keyboard Shortcuts** and searching for 
`last`. I set it to `Ctrl + \` so that I can run a block of code with 
`Ctrl + Enter` and then insert the result immediately with `Ctrl + \`.

![](https://github.com/DesiQuintans/carboncopy/blob/main/readme_files/keyboard_bindings.png?raw=true)

### From the Addins menu

![](https://github.com/DesiQuintans/carboncopy/blob/main/readme_files/addins_menu.png?raw=true)

### From the Command Palette (by default, `Ctrl + Shift + P`)

![](https://github.com/DesiQuintans/carboncopy/blob/main/readme_files/command_palette.png?raw=true)


## Use it...

Note that the width of the output comment is based on the width of your Console
Pane *at the time you insert the comment*. This is because the add-in tells R to
print `.Last.value` to the current console, then captures that output and
redirects it. Simply put, if your output is too wide or too narrow:

``` r
head(iris)
#   Sepal.Length Sepal.Width
# 1          5.1         3.5
# 2          4.9         3.0
# 3          4.7         3.2
# 4          4.6         3.1
# 5          5.0         3.6
# 6          5.4         3.9
#   Petal.Length Petal.Width
# 1          1.4         0.2
# 2          1.4         0.2
# 3          1.3         0.2
# 4          1.5         0.2
# 5          1.4         0.2
# 6          1.7         0.4
#   Species
# 1  setosa
# 2  setosa
# 3  setosa
# 4  setosa
# 5  setosa
# 6  setosa
#     < Last run: 2023-09-26 13:28>
```

Then either zoom out in RStudio with `[Ctrl] + [-]` to make the text smaller, or change the width of your Console Pane, and then try again:

``` r
head(iris)
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa
#     < Last run: 2023-09-26 13:28>
```


### With functions that return something

Most R expressions return something that gets saved to `.Last.value`, so in most
cases you can run a block of code and then invoke _Insert .Last.value as a
comment_ to insert the output in your document:

``` r
summary(beaver1$temp)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 36.33   36.76   36.87   36.86   36.96   37.53 
#     < Last run: 2023-09-26 13:29>
```

### With functions that return nothing except Console output

Some R expressions only print to the Console but return nothing. For example, 
`stem()` prints a text histogram to the Console but returns `NULL`, so this 
happens when you insert the last output:

``` r
stem(warpbreaks$breaks)
# NULL
#     < Last run: 2023-09-26 13:31>
```

To capture the output of these, highlight the entire expression and then invoke 
_Insert .Last.value as a comment_. It will run your expression for you, capture 
the output directly, and insert it below.

``` r
stem(warpbreaks$breaks)
# The decimal point is 1 digit(s) to the right of the |
# 
# 1 | 0234555667788899
# 2 | 001111445666678889999
# 3 | 00156699
# 4 | 1234
# 5 | 124
# 6 | 7
# 7 | 0
# 
#     < Last run: 2023-09-26 13:34>
```
