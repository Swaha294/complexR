#' Visualize stereographic projections from \eqn{\mathbb{C}} to \eqn{\mathbb{C}^*}
#'
#' @param a A numeric vector. The real coordinate (\eqn{x}-coordinate) of the number
#' in \eqn{\mathbb{C}}.
#' @param b A numeric vector. The imaginary coordinate (\eqn{y}-coordinate) of the
#' number in \eqn{\mathbb{C}}.
#'
#' @return A visualization of the point in \eqn{\mathbb{C}} and its corresponding
#' projection in \eqn{\mathbb{C}^*}.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Visualize the stereographic projection of x = 2 + 3i on the Riemann sphere
#' st_sphere_plot(a = 2, b = 3)
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2

st_sphere_plot <- function(a, b) {

  p = plane_to_sphere(a, b)

  point = ggplot() +
    geom_point(aes(x = a, y = b)) +
    xlim(a - 3, a + 3) +
    ylim(b - 3, b + 3) +
    labs(
      x = "Re z",
      y = "Im z",
      title = "Complex Plane"
    ) +
    theme_bw()

  x = p[1]
  y = p[2]
  z = p[3]

  xy = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "x",
      y = "y",
      title = "X-Y view"
    ) +
    geom_point(aes(x = x, y = y)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  yz = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "y",
      y = "z",
      title = "Y-Z view"
    ) +
    geom_point(aes(x = y, y = z)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  zx = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "z",
      y = "x",
      title = "Z-X view"
    ) +
    geom_point(aes(x = z, y = x)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  sphere = ggpubr::ggarrange(xy, yz, zx, nrow = 1)

  ggpubr::ggarrange(point, sphere, nrow = 2)

}
