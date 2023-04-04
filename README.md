
# complexR

## Overview

`complexR` is a tool for easily computing and visualizing
transformations on complex numbers:

- `circle_transform()` performs and visualizes any kind of
  transformation on circles

- `line_transform()` performs and visualizes any kind of transformation
  on lines

- `quad_transform()` performs and visualizes any kind of transformation
  on squares and rectangles

- `plane_to_sphere()` and `sphere_to_plane()` compute stereographic
  projections

- `st_sphere_plot()` and `st_plane_plot()` visualize them.

These functions combine other intermediary functions like
`cart_to_polar()` and `polar_to_cart()` to execute their operations. You
can learn more about them in `vignette("complexR")`.

## Installation

Use this code to download the development version of `complexR`.

``` r
devtools::install_github("Swaha294/complexR")
```

    ## Downloading GitHub repo Swaha294/complexR@HEAD

    ## bit   (4.0.4 -> 4.0.5) [CRAN]
    ## hms   (1.1.2 -> 1.1.3) [CRAN]
    ## vroom (1.6.0 -> 1.6.1) [CRAN]
    ## readr (2.1.3 -> 2.1.4) [CRAN]

    ## Installing 4 packages: bit, hms, vroom, readr

    ## 
    ## The downloaded binary packages are in
    ##  /var/folders/0p/hkwpsbqj047d4nq34kz3_wdr0000gn/T//RtmpEmOQz8/downloaded_packages
    ##      checking for file ‘/private/var/folders/0p/hkwpsbqj047d4nq34kz3_wdr0000gn/T/RtmpEmOQz8/remotesf71527b1ec40/Swaha294-complexR-33d53b5/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/0p/hkwpsbqj047d4nq34kz3_wdr0000gn/T/RtmpEmOQz8/remotesf71527b1ec40/Swaha294-complexR-33d53b5/DESCRIPTION’ (402ms)
    ##   ─  preparing ‘complexR’:
    ##      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
    ##   ─  checking for LF line-endings in source and make files and shell scripts
    ##   ─  checking for empty or unneeded directories
    ##   ─  building ‘complexR_0.0.0.9000.tar.gz’
    ##      
    ## 

## Usage

Visualize the transformation $f(z) = 2xy + iy^2$ on the unit circle
centered at (1, 0)

``` r
library(complexR)
circle_transform(
  x0 = 1, 
  x_new = expression(2*x*y), 
  y_new = expression(y^2),
  annotations = c(complex(real = 2, imaginary = 0), complex(real = 1, imaginary = 1))
  )
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
