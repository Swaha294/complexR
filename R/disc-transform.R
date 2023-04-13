#' Visualize transformations on discs in the complex plane
#'
#' @param r_inner A numeric vector. The inner radius of the disc, with default
#' value \eqn{0}.
#' @param r_outer A numeric vector. The outer radius of the disc, with default
#' value \eqn{1}.
#' @param x0 A numeric vector. The x-coordinate of the circle's center, with
#' default value \eqn{0}.
#' @param y0 A numeric vector. The y-coordinate of the circle's center, with
#' default value \eqn{0}.
#' @param x_new An object of class expression. The real part of the complex
#' number obtained from the transformation. The default value is set to
#' \eqn{expression(x^2 + y^2)}, corresponding to the transformation \eqn{z^2}.
#' @param y_new An object of class expression. The imaginary part of the complex
#' number obtained from the transformation. The default value is set to
#' \eqn{expression(2xy)}, corresponding to the transformation \eqn{z^2}.
#' @param theta_min A numeric vector. The lower bound of the \eqn{\theta} corresponding
#' to the part of the circle that is part of the domain. The default value is
#' set to \eqn{0}.
#' @param theta_max A numeric vector. The upper bound of the \eqn{\theta} corresponding
#' to the part of the circle that is part of the domain. The default value is set
#' to \eqn{2 \pi}.
#'
#' @return A visualization with the domain and the image obtained from the
#' transformation on all points of the domain.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Visualize the transformation z^2 on all points on the unit circle centered at
#' # (1, 0)
#' disc_transform(x0 = 1)
#'
#' # Visualize the transformation f(x + iy) = (x^3 - y^2) + i(2xy) on all points
#' # of the first 1/6 of the circle of radius 2 centered at (1, 1)
#' disc_transform(x0 = 1, y0 = 1, x_new = expression(x^3 - y^2),
#' y_new = expression(2*x*y), theta_min = 0, theta_max = pi/3)
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2

# creating function to perform any simple transformation on a circle
disc_transform <- function(r_inner = 0, r_outer = 1, x0 = 0, y0 = 0, x_new = expression(x^2 - y^2),
                             y_new = expression(2*x*y), theta_min = 0, theta_max = 2*pi) {

  if (!is.numeric(r_inner) | !is.numeric(x0) | !is.numeric(y0) | !is.numeric(theta_min) |
      !is.numeric(theta_max) | !is.numeric(r_outer)) {
    # checking if inputs are numbers
    stop("Check input: r_inner, r_outer, x0, y0, theta_min, and theta_max should be numbers",
         call. = FALSE)
  } else if (r_inner < 0 | r_outer <= 0) {
    # checking that r_inner and r_outer are numbers greater than 0
    stop("Check input: r_inner and r_outer should be a number greater than 0",
         call. = FALSE)
  } else if (r_inner >= r_outer) {
    # checking that r_inner is less than r_outer
    stop("Check input: r_inner should be less than r_outer", call. = FALSE)
  } else if (theta_min < 0 | theta_min > 2*pi) {
    # checking that theta_min is between 0 and 2pi
    stop(paste("Check input: theta_min should be between 0 and", 2*pi), call. = FALSE)
  } else if (theta_max < 0 | theta_max > 2*pi) {
    # checking that theta_max is between 0 and 2pi
    stop(paste("Check input: theta_max should be between 0 and", 2*pi), call. = FALSE)
  } else if (theta_min >= theta_max) {
    # checking that theta_min is less than and not equal to theta_max
    stop("Check input: theta_min should be less than theta_max", call. = FALSE)
  } else if (!is.expression(x_new) | !is.expression(y_new)) {
    # checking that x_new and y_new are expressions
    stop("Check input: x_new and y_new should be objects of class 'expression'", call. = FALSE)
  } else {

    # creating list with theta between theta_min and theta_max
    thetas = stats::runif(300, theta_min, theta_max)

    # creating list with r between r_inner and r_outer
    rs = stats::runif(400, r_inner, r_outer)

    # creating data set for disc centered at (0, 0)
    my_disc = purrr::map2_df(rs, thetas[1], polar_to_cart)

    for (i in 2:length(thetas)) {

      my_disc = rbind(my_disc, purrr::map2_df(rs, thetas[i], polar_to_cart))

    }

    # adjusting for center at (x0, y0)
    my_disc = my_disc %>%
      dplyr::mutate(
        x = x + x0,
        y = y + y0
      )

    # creating visualization of domain circle
    domain = ggplot(
      data = my_disc,
      mapping = aes(x = x, y = y)
    ) +
      geom_point(
        alpha = 0.3,
        color = "orchid3",
        size = 7
      ) +
      xlim(
        min(my_disc$x) - 2,
        max(my_disc$x) + 2
        ) +
      ylim(
        min(my_disc$y) - 2,
        max(my_disc$y) + 2
        ) +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Domain"
      )


    # creating new data set with transformation
    my_disc = my_disc %>%
      dplyr::mutate(
        x_new = eval(x_new, list(x = x, y = y)),
        y_new = eval(y_new, list(x = x, y = y))
        )

    # creating visualisaton for image
    image = ggplot(
      data = my_disc,
      mapping = aes(x = x_new, y = y_new)
    ) +
      geom_point(
        alpha = 0.3,
        color = "orchid3",
        size = 7
      ) +
      xlim(
        min(my_disc$x_new) - 2,
        max(my_disc$x_new) + 2
      ) +
      ylim(
        min(my_disc$y_new) - 2,
        max(my_disc$y_new) + 2
      ) +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Image"
      )


    # creating visualization with domain and image
    ggpubr::ggarrange(domain, image)

  }

}

