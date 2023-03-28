#' Convert complex Cartesian coordinates to polar coordinates
#'
#' @param real A numeric vector, the real part of the complex number
#' @param imaginary A numeric vector, the imaginary part of the complex number
#'
#' @return A list with two elements, `r` and `theta`, which correspond to the polar
#' components of the complex number given in Cartesian coordinates.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Convert the complex number, z = 1 + 6i to polar form.
#' cart_to_polar(1, 6)
#'


cart_to_polar <- function(real, imaginary) {

  # checking that inputs are numeric
  if (!is.numeric(real)|!is.numeric(imaginary)) {
    stop("Both inputs should be numbers", call. = FALSE)
  } else {
    z <- complex(real = real, imaginary = imaginary)
    r <- sqrt(real^2 + imaginary^2)
    # checking which quadrant number is in
    if (real >= 0 & imaginary >= 0) {
      theta <- atan(imaginary/real)
    } else if (real < 0 & imaginary >= 0) {
      theta <- atan(imaginary/real) + pi
    } else if (real < 0 & imaginary < 0) {
      theta <- atan(imaginary/real) + pi
    } else if (real >= 0 & imaginary < 0) {
      theta <- atan(imaginary/real)
    }
  }

  return(c(r = r, theta = theta))

}
