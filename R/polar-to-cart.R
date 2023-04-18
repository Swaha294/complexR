#' Convert complex polar coordinates to Cartesian coordinates
#'
#' @param r A numeric vector, the radius of the complex number in polar form
#' @param theta A numeric vector, the angle of the complex number in polar form, between
#' -pi and pi.
#'
#' @return A list with two elements, `x` and `y`, which correspond to the Cartesian
#' components of the complex number given in polar coordinates.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Convert the complex number, z = 3(cos(pi/2) + i sin(pi/2)) to Cartesian form.
#' polar_to_cart(3, pi/2)
#'
#' @export


polar_to_cart <- function(r, theta) {

  if (!is.numeric(r) | !is.numeric(theta)) {
    # checking that r and theta are numbers
    stop("Check input: r and theta should be numbers", call. = FALSE)
  } else if (0 > theta | 2*pi < theta) {
    # checking that theta is between 0 and 2pi
    stop(paste("Check input: theta should be between", 0, "and", 2*pi), call. = FALSE)
  } else if (r < 0) {
    # checking that r >= 0
    stop("Check input: r should be greater than or equal to 0")
  } else {

    # checking whether theta / pi is a multiple of 1/2
    q = theta / pi

    if (is.integer(0.5 / q) | is.integer(q / 0.5)) {

      # computing x
      x = round(r*cospi(q), 10)
      # computing y
      y = round(r*sinpi(q), 10)

    } else {

      # computing x
      x = round(r*cos(theta), 10)
      # computing y
      y = round(r*sin(theta), 10)

    }

    z = c(x = x, y = y)

    return(z)
  }

}
