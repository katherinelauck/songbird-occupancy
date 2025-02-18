% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/R-PRES.r
\name{predict.occMod}
\alias{predict.occMod}
\title{Predict real parameter values.}
\usage{
\method{predict}{occMod}(object, newdata, param = NULL, conf = 0.95)
}
\arguments{
\item{object}{and object of class \code{occMod} which is the model that has been fitted to
the data from which predictions are required. The result of a call to \code{\link{occMod}}.}

\item{newdata}{a data frame containing the values of the variables for which predictions are
required. Variable names must exactly match those used in the fitted model. May contain
additional variables not used in the fitted model.}

\item{param}{a string containing the name of the real parameter for which predictions
are required, e.g., \code{type="psi"}.}

\item{conf}{level for confidence interval (may be vector valued).}
}
\value{
returns a data frame containing the predicted value, standard error and limits of a
95\% confidence interval.
}
\description{
Predict real parameter values from a model that has been fitted to the data, using the
variable or covariates values that are supplied by the user. \bold{Currently has only been coded
to predict probabilities and checked for the static, or single-season, occupancy model.}
}
\details{
Note that can not make predictions directly from models that have been imported from a PRESENCE
project using the \code{\link{importProject}} function.
}
\examples{
psi.real=predict(mod1,salmdr.data$survcov,param="psi",conf=0.95); print(head(psi.real))
}
\seealso{
\code{\link{occMod}}
}
\author{
Darryl MacKenzie
}
