#' Visualize transformations on circles in the complex plane
#'
#' @param r A numeric vector. The radius of the circle, with default value \eqn{1}.
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
#' @param annotations A list of complex numbers. An optional list of complex numbers
#' you want to visualize.
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
#' circle_transform(x0 = 1)
#'
#' # Visualize the transformation 1/z on all points of the first two
#' # quadrants of the circle of radius 2 centered at (1, 1)
#' circle_transform(r = 2, x0 = 1, y0 = 1, x_new = expression(x / (x^2 + y^2)),
#' y_new = expression(-y / (x^2 + y^2)), theta_min = 0, theta_max = pi)
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2


# creating function to perform any simple transformation on a circle
circle_transform <- function(r = 1, x0 = 0, y0 = 0, x_new = expression(x^2 - y^2),
                             y_new = expression(2*x*y), theta_min = 0, theta_max = 2*pi,
                             annotations = NULL) {

  if (!is.numeric(r) | !is.numeric(x0) | !is.numeric(y0) | !is.numeric(theta_min) |
      !is.numeric(theta_max)) {
    # checking if inputs are numbers
    stop("Check input: r, x0, y0, theta_min, and theta_max should be numbers", call. = FALSE)
  } else if (r <= 0) {
    # checking that r is a number greater than 0
    stop("Check input: r should be a number greater than 0", call. = FALSE)
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
  } else if (!is.null(annotations) & !is.complex(annotations)) {
    # checking that annotations is a list of complex numbers
    stop("Check input: annotations should be a list of complex numbers", call. = FALSE)
  } else {

    # creating data set with theta between theta_min and theta_max
    thetas = stats::runif(20000, theta_min, theta_max)

    # creating data set for circle of radius r centered at (0, 0)
    my_circle = purrr::map2_df(r, thetas, polar_to_cart)

    # adjusting for center at (x0, y0)
    my_circle = my_circle %>%
      dplyr::mutate(
        x = x + x0,
        y = y + y0
      )

    # adding annotations if given

    if (!is.null(annotations)) {

      all_real = c()
      all_imaginary = c()

      for (i in annotations) {

        all_real = c(
          all_real,
          Re(i)
        )

        all_imaginary = c(
          all_imaginary,
          Im(i)
        )

      }

      # checking that all annotations are on the circle
      n = 1

      while (n <= length(all_real)) {

        x = all_real[n]
        y = all_imaginary[n]

        if ((x - x0)^2 + (y - y0)^2 == r^2) {
          n = n + 1
        } else {
          stop("Check input: All annotations should lie on the given circle", call. = FALSE)
        }

      }

      my_points = data.frame(
        x = all_real,
        y = all_imaginary
      ) %>%
        dplyr::mutate(
          x_new = eval(x_new, list(x = x, y = y)),
          y_new = eval(y_new, list(x = x, y = y)),
          exp = paste0("(", x, ", ", y, ")"),
          exp_f = paste0("f(", x, ", ", y, ")")
        )

    }


    # creating visualization of domain circle
    domain = ggplot(
      data = my_circle,
      mapping = aes(x = x, y = y)
    ) +
      geom_point() +
      geom_hline(yintercept = y0, linetype = "dashed") +
      geom_vline(xintercept = x0, linetype = "dashed") +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Domain"
      )

    # adding annotations if given
    if (!is.null(annotations)) {

      domain = domain +
        geom_point(
          data = my_points,
          mapping = aes(x = x, y = y),
          size = 2.5,
          color = "orchid2"
        ) +
        ggrepel::geom_label_repel(
          data = my_points,
          mapping = aes(label = exp)
        )

    }

    # creating new data set with transformation
    my_circle = my_circle %>%
      dplyr::mutate(
        x_new = eval(x_new, list(x = x, y = y)),
        y_new = eval(y_new, list(x = x, y = y))
      )

    # creating visualisaton for image
    image = ggplot(
      data = my_circle,
      mapping = aes(x = x_new, y = y_new)
    ) +
      geom_point() +
      geom_hline(yintercept = y0, linetype = "dashed") +
      geom_vline(xintercept = x0, linetype = "dashed") +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Image"
      )

    # adding annotations if given
    if (!is.null(annotations)) {

      image = image +
        geom_point(
          data = my_points,
          mapping = aes(x = x_new, y = y_new),
          size = 2.5,
          color = "orchid2"
        ) +
        ggrepel::geom_label_repel(
          data = my_points,
          mapping = aes(label = exp_f)
        )

    }

    # creating visualization with domain and image
    ggpubr::ggarrange(domain, image)

    }

}



