% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/reactives.R
\name{observeEvent}
\alias{eventReactive}
\alias{observeEvent}
\title{Event handler}
\usage{
observeEvent(eventExpr, handlerExpr, event.env = parent.frame(),
  event.quoted = FALSE, handler.env = parent.frame(),
  handler.quoted = FALSE, label = NULL, suspended = FALSE, priority = 0,
  domain = getDefaultReactiveDomain(), autoDestroy = TRUE,
  ignoreNULL = TRUE)

eventReactive(eventExpr, valueExpr, event.env = parent.frame(),
  event.quoted = FALSE, value.env = parent.frame(), value.quoted = FALSE,
  label = NULL, domain = getDefaultReactiveDomain(), ignoreNULL = TRUE)
}
\arguments{
\item{eventExpr}{A (quoted or unquoted) expression that represents the event;
this can be a simple reactive value like \code{input$click}, a call to a
reactive expression like \code{dataset()}, or even a complex expression
inside curly braces}

\item{handlerExpr}{The expression to call whenever \code{eventExpr} is
invalidated. This should be a side-effect-producing action (the return
value will be ignored). It will be executed within an \code{\link{isolate}}
scope.}

\item{event.env}{The parent environment for \code{eventExpr}. By default,
this is the calling environment.}

\item{event.quoted}{Is the \code{eventExpr} expression quoted? By default,
this is \code{FALSE}. This is useful when you want to use an expression
that is stored in a variable; to do so, it must be quoted with
\code{quote()}.}

\item{handler.env}{The parent environment for \code{handlerExpr}. By default,
this is the calling environment.}

\item{handler.quoted}{Is the \code{handlerExpr} expression quoted? By
default, this is \code{FALSE}. This is useful when you want to use an
expression that is stored in a variable; to do so, it must be quoted with
\code{quote()}.}

\item{label}{A label for the observer or reactive, useful for debugging.}

\item{suspended}{If \code{TRUE}, start the observer in a suspended state. If
\code{FALSE} (the default), start in a non-suspended state.}

\item{priority}{An integer or numeric that controls the priority with which
this observer should be executed. An observer with a given priority level
will always execute sooner than all observers with a lower priority level.
Positive, negative, and zero values are allowed.}

\item{domain}{See \link{domains}.}

\item{autoDestroy}{If \code{TRUE} (the default), the observer will be
automatically destroyed when its domain (if any) ends.}

\item{ignoreNULL}{Whether the action should be triggered (or value
calculated, in the case of \code{eventReactive}) when the input is
\code{NULL}. See Details.}

\item{valueExpr}{The expression that produces the return value of the
\code{eventReactive}. It will be executed within an \code{\link{isolate}}
scope.}

\item{value.env}{The parent environment for \code{valueExpr}. By default,
this is the calling environment.}

\item{value.quoted}{Is the \code{valueExpr} expression quoted? By default,
this is \code{FALSE}. This is useful when you want to use an expression
that is stored in a variable; to do so, it must be quoted with \code{quote()}.}
}
\value{
\code{observeEvent} returns an observer reference class object (see
  \code{\link{observe}}). \code{eventReactive} returns a reactive expression
  object (see \code{\link{reactive}}).
}
\description{
Respond to "event-like" reactive inputs, values, and expressions.
}
\details{
Shiny's reactive programming framework is primarily designed for calculated
values (reactive expressions) and side-effect-causing actions (observers)
that respond to \emph{any} of their inputs changing. That's often what is
desired in Shiny apps, but not always: sometimes you want to wait for a
specific action to be taken from the user, like clicking an
\code{\link{actionButton}}, before calculating an expression or taking an
action. A reactive value or expression that is used to trigger other
calculations in this way is called an \emph{event}.

These situations demand a more imperative, "event handling" style of
programming that is possible--but not particularly intuitive--using the
reactive programming primitives \code{\link{observe}} and
\code{\link{isolate}}. \code{observeEvent} and \code{eventReactive} provide
straightforward APIs for event handling that wrap \code{observe} and
\code{isolate}.

Use \code{observeEvent} whenever you want to \emph{perform an action} in
response to an event. (Note that "recalculate a value" does not generally
count as performing an action--see \code{eventReactive} for that.) The first
argument is the event you want to respond to, and the second argument is a
function that should be called whenever the event occurs.

Use \code{eventReactive} to create a \emph{calculated value} that only
updates in response to an event. This is just like a normal
\link[=reactive]{reactive expression} except it ignores all the usual
invalidations that come from its reactive dependencies; it only invalidates
in response to the given event.

Both \code{observeEvent} and \code{eventReactive} take an \code{ignoreNULL}
parameter that affects behavior when the \code{eventExpr} evaluates to
\code{NULL} (or in the special case of an \code{\link{actionButton}},
\code{0}). In these cases, if \code{ignoreNULL} is \code{TRUE}, then an
\code{observeEvent} will not execute and an \code{eventReactive} will raise a
silent \link[=validate]{validation} error. This is useful behavior if you
don't want to do the action or calculation when your app first starts, but
wait for the user to initiate the action first (like a "Submit" button);
whereas \code{ignoreNULL=FALSE} is desirable if you want to initially perform
the action/calculation and just let the user re-initiate it (like a
"Recalculate" button).
}
\examples{
## Only run this example in interactive R sessions
if (interactive()) {
  ui <- fluidPage(
    column(4,
      numericInput("x", "Value", 5),
      br(),
      actionButton("button", "Show")
    ),
    column(8, tableOutput("table"))
  )
  server <- function(input, output) {
    # Take an action every time button is pressed;
    # here, we just print a message to the console
    observeEvent(input$button, {
      cat("Showing", input$x, "rows\\n")
    })
    # Take a reactive dependency on input$button, but
    # not on any of the stuff inside the function
    df <- eventReactive(input$button, {
      head(cars, input$x)
    })
    output$table <- renderTable({
      df()
    })
  }
  shinyApp(ui=ui, server=server)
}
}
\seealso{
\code{\link{actionButton}}
}

