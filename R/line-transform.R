#' Visualize transformations on straight lines in the complex plane
#'
#' @param m A numeric vector. The slope of the line, with default value set to \eqn{1}.
#' Set to \eqn{\infty} for horizontal line.
#' @param c A numeric vector. The \eqn{y} intercept of the line, with default
#' value set to \eqn{0}.
#' @param x_new An expression. The real part of the complex transformation with
#' default set to \eqn{x^2 - y^2} corresponding to the \eqn{z^2} transformation.
#' @param y_new An expression. The imaginary part of the complex transformation
#' with default set to \eqn{2xy} corresponding to the \eqn{z^2} transformation.
#' @param x_interecept A numeric vector. The \eqn{x}-intercept of the line when
#' the line is parallel to the \eqn{y}-axis. Default value set to \eqn{1}.
#'
#' @return A visualization with the domain and the image obtained from the
#' transformation on all points of the domain.
#'
#' @examples
#' library(complexR)
#'
#' # Visualize the transformation z^2 on the line y = 3x + 5
#' line_transform(m = 3, c = 5)
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2
#'

# write function for transformation of any line
line_transform <- function(m = 1, c = 0, x_new = expression(x^2 - y^2),
                           y_new = expression(2*x*y), xintercept = 1,
                           annotations = NULL) {

  if (!is.numeric(m) | !is.numeric(c) & abs(m) != Inf | !is.numeric(xintercept)) {
    # checking that m and c are numbers
    stop("Check input: m, c, and xintercept should should be numbers", call. = FALSE)
  } else if (!is.expression(x_new) | !is.expression(y_new)) {
    # checking that x_new and y_new are expressions
    stop("Check input: x_new and y_new should be objects of class 'expression'", call. = FALSE)
  } else if (!is.null(annotations) & !is.complex(annotations)) {
    # checking that annotations is a list of complex numbers
    stop("Check input: annotations should be a list of complex numbers", call. = FALSE)
  } else {

    # checking whether slope m is infinity
    if (abs(m) == Inf) {

      # setting all x to xintercept
      my_x = rep(xintercept, 20000)
      # getting all y
      my_y = runif(20000, -5, 5)

    } else if (m == 0) {

      # setting all y to c for horizontal line for m = 0
      my_y = rep(c, 20000)
      # getting all x
      my_x = runif(20000, -5, 5)

    } else {

      # getting all y
      my_y = runif(20000, c - 5, c + 5)
      # getting all x
      my_x = (my_y - c) * m

    }

    # getting data set

    my_line = data.frame(
      x = my_x,
      y = my_y
    )

    # creating data for annotations
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

      # creating data set of all annotations
      my_points = data.frame(
        "x" = all_real,
        "y" = all_imaginary
      )

      # checking that annotations are on the line
      if (abs(m) == Inf) {

        n = my_points %>%
          dplyr::filter(x != xintercept) %>%
          nrow()

        if (n != 0) {
          stop("Check input: not all annotations are on the given line", call. = FALSE)
        }

      } else if (m == 0) {

        n = my_points %>%
          dplyr::filter(y != c) %>%
          nrow()

        if (n != 0) {
          stop("Check input: not all annotations are on the given line", call. = FALSE)
        }

      } else {

        n = my_points %>%
          dplyr::filter(y != m*x + c) %>%
          nrow()

          if (n != 0) {
            stop("Check input: not all annotations are on the given line", call. = FALSE)
          }

        }

      my_points = my_points %>%
        dplyr::mutate(
          x_new = eval(x_new, list(x = x, y = y)),
          y_new = eval(y_new, list(x = x, y = y)),
          exp = paste0("(", x, ", ", y, ")"),
          exp_f = paste0("f(", x, ", ", y, ")")
        )

    }

    # getting image for domain
    domain = ggplot(
      data = my_line,
      mapping = aes(x = x, y = y)
    ) +
      geom_point() +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_vline(xintercept = 0, linetype = "dashed") +
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
    my_line = my_line %>%
      dplyr::mutate(
        x_new = eval(x_new, list(x = x, y = y)),
        y_new = eval(y_new, list(x = x, y = y))
      )

    # creating visualisation for image
    image = ggplot(
      data = my_line,
      mapping = aes(x = x_new, y = y_new)
    ) +
      geom_point() +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_vline(xintercept = 0, linetype = "dashed") +
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

    ggpubr::ggarrange(domain, image)

  }

}
