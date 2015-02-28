# covarmat_class
# class for evaluated covariance matrices

# To do:
#   fix the colour scheme in image

#' @name covarmat
#' @rdname covarmat
#'
#' @title gpe covariance matrix class
#' 
#' @description Generic functions associated with the covarmat class.
#' 
#' @param x an object of class \code{covarmat}, or an object to be tested as one.
#' 
#' @details \code{is.covarmat} returns a logical indicating whether the 
#' object is a gpe \code{covarmat} object and \code{image.covarmat} provides 
#' a nice plot of the values in the covariance matrix; in the style of, and 
#' depending on \code{\link{image.plot}}.
#' 
#' @examples
#'  
#' # construct a kernel with one feature
#' k1 <- rbf('a')
#' 
#' # create a fake dataframe
#' df <- data.frame(a = sort(runif(50, -3, 3)))
#'  
#' # evaluate the kernel
#' K <- k1(df)
#' 
NULL

# covariance matrix constructor
as.covarmat <- function (x) {
  class(x) <- c('covarmat')
  return (x)
}

#' @rdname covarmat
#' @export
#' @examples
#' 
#' # is it a covarmat object? 
#' is.covarmat(K)
#'  
is.covarmat <- function (x) {
  'covarmat' %in% class(x)
}

#' @rdname covarmat
#' 
#' @param axes whether to add axes to the image plot of \code{x}.
#' 
#' @param legend whether to add a legend to the image plot of \code{x}.
#' 
#' @param \dots other arguments to be passed to lower-level functions, such as 
#' image.
#' 
#' @export
#' @examples
#' 
#' # visualise it 
#' image(K)
#' 
#' # create a new dataframe
#' df2 <- data.frame(a = sort(runif(100, -3, 3)))
#' 
#' # visualise the covariance matrix between the two dataframes
#' image(k1(df, df2))
#' 
image.covarmat <- function (x, axes = TRUE, legend = TRUE, ...) {
  # define a plot function for covariance matrices
  
  # dimension
  nx <- ncol(x)
  ny <- nrow(x)
  
  # flip the matrix round (image does this for some reason)
  z <- as.matrix(t(x[ny:1, ]))
  
  # axis numbers
  x <- 1:nx
  y <- 1:ny
  
  # use image plot, make the legend plot fail silently
  tmp <- tryCatch(fields::image.plot(x = x,
                                     y = y,
                                     z = z,
                                     useRaster = TRUE,
                                     ylab = '',
                                     xlab = '',
                                     axes = FALSE,
                                     ...,
                                     legend.shrink = NA),
                  error = function(e) NULL)
  
  if (axes) {
    
    # get the axis points at which to print matrix indices
    by <- min(nx, ny) %/% 5
    at_x <- seq(0, nx, by = by)
    at_y <- seq(0, ny, by = by)
    
    # add axes
    axis(3,
         at_x[-1],
         at_x[-1],
         tick = FALSE,
         cex.axis = 0.8,
         line = -0.5)
    
    axis(2,
         at_y[-length(at_y)] + 1,
         rev(at_y[-1]),
         tick = FALSE,
         cex.axis = 0.8,
         line = -0.5,
         las = 2)
    
    # axis labels
    mtext('K_j',
          side = 3,
          line = 2,
          at = nx / 2)
    
    mtext('K_i',
          side = 2,
          line = 2,
          at = ny / 2,
          las = 2)
    
  }
  
  if (legend) {
    
    # add the legend
    fields::image.plot(x = x,
                       y = y,
                       z = z,
                       useRaster = TRUE,
                       ylab = '',
                       xlab = '',
                       axes = FALSE,
                       ...,
                       legend.only = TRUE,
                       add = TRUE,
                       ...)
  }
}