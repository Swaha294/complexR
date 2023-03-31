
#' Perform a stereographic projection to project a point on the complex plane to the Riemann sphere
#'
#' @param a A numeric vector.
#' @param b A numeric vector.
#'
#' @return A list with the coordinates of the point obtained from the projection
#' of the input to the Riemann sphere.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Convert the complex number z = 1 + 3i to a point on the Riemann sphere
#'
#' plane_to_sphere(1, 3)
#'
#' @export


plane_to_sphere <- function(a, b) {

  # checking that a and b are numbers
  if (!is.numeric(a) | !is.numeric(b)) {

    stop("Inputs should be numeric")

  } else if (a == Inf | b == Inf | a == -Inf | b == -Inf) {

    # returning north pole if input is infinity
    p = c(0, 0, 1)
    return(p)

  }

  else {

    # creating complex number
    w = complex(real = a, imaginary = b)

    # calculating square of modulus of w
    mod_w_sq = Mod(w)^2

    # calculating x coordinate of P
    x = 2 * a / (mod_w_sq + 1)
    # calculating y coordinate of P
    y = 2 * b / (mod_w_sq + 1)
    # calculating z coordinate of P
    z = (mod_w_sq - 1) / (mod_w_sq + 1)

    # returning vector p = c(x, y, z)
    p = c(x, y, z)
    return(p)

  }

}
