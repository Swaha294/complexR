#' Perform a stereographic projection to project a point on the Riemann sphere to the complex plane
#'
#' @param x A numeric vector.
#' @param y A numeric vector.
#' @param z A numeric vector.
#'
#' @return The complex number `w` obtained from the projection of the input to the complex plane.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Convert the point (1/3, 2/3, 2/3) on the Riemann sphere to a point on the complex plane
#'
#' sphere_to_plane(1/3, 2/3, 2/3)
#'
#' @export

# add part for north pole
sphere_to_plane <- function(x, y, z) {

  if (!is.numeric(x) | !is.numeric(y) | !is.numeric(z)) {
    # checking that x, y, and z are numbers
    stop("Check input: x, y, z should be numeric", call. = FALSE)
  }  else {

    nums = c(x, y, z)
    nums = MASS::as.fractions(nums)

    if (x == 0 & y == 0 & z == 1) {
      # setting w to infinity if P is the north pole
      w = Inf

      # returning w
      return(w)
    } else if (as.integer(nums[1]^2 + nums[2]^2 + nums[3]^2) == 1L) {
      # calculating real part of w
      u = x / (1 - z)
      # calculating imaginary part of w
      v = y / (1 - z)
      # computing complex number
      w = complex(real = u, imaginary = v)

      # returning w
      return(w)
    } else {
      # checking that given point is on the unit sphere
      stop("Given point is not on the unit sphere", call. = FALSE)
    }

  }


}
