
#' Insert the contents of `.Last.value` as a comment
#'
#' '.Last.value' is a built-in variable from the 'base' package that contains
#' the output of the last top-level expression that was run. This add-in function
#' grabs that output, turns it into a comment, and inserts it into the current
#' source document at the current cursor position. It also adds a datestamp.
#'
#' @return Character vector.
#' @export
cc_insert_lastvalue <- function() {
    stopifnot(
        "'carboncopy' can only be used in an interactive session." = interactive(),
        "'carboncopy' can only be used inside RStudio." = rstudioapi::isAvailable()
    )

    # This function does different things based on whether text is
    # selected or not.
    editor <- rstudioapi::getActiveDocumentContext()

    selected_text <- rstudioapi::primary_selection(editor)$text

    if (selected_text != "") {
        # Something is selected, so evaluate it.
        # NOTE: This is evaluated and captured in the same function call so
        # that the output of functions that write to the console but otherwise
        # return nothing (e.g. `stem()`) can be captured.
        out <- utils::capture.output(eval(parse(text = selected_text)))

        # Also put the cursor on the line below the current selection, otherwise
        # the comment output will overwrite the code.
        next_line <- editor$selection[[1]]$range$end[[1]] + 1

        if (length(editor$contents) <= next_line) {                             # Insert new line if cursor is at end of document.
            rstudioapi::setCursorPosition(c(next_line, 1))
            rstudioapi::insertText("\n")
        }

        rstudioapi::setCursorPosition(c(next_line, 1))
    } else {
        # Nothing is selected, so use .Last.value.
        out <- utils::capture.output(.Last.value)
    }

    # Some outputs pad themselves with unwanted whitespace on the left:
    #
    # > utils::capture.output(summary(warpbreaks$breaks))
    # > [1] "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. "
    # > [2] "  10.00   18.25   26.00   28.15   34.00   70.00 "
    #
    # I want to remove these whenever they exist to standardise my output.
    #
    # IMPORTANT: This unpadding MUST be done inside this function. Refactoring
    # it to a separate function means that .Last.value will get overwritten even
    # if invisible().

    nonempty <- out[which(nchar(trimws(out)) > 0)]

    # Remove this many spaces from every line.
    n_spaces <- min(nchar(nonempty) - nchar(trimws(nonempty, which = "left")))

    # Assemble output and datestamp
    out <- c(substr(x     = out,
                    start = n_spaces + 1,  # +1 so that it skips n = `n_spaces` chars.
                    stop  = .Machine$integer.max),
             format(Sys.time(), "    < Last run: %Y-%m-%d >"))

    if (nchar(trimws(out[1])) == 0) {  # If first line is empty, omit it.
        out <- out[-1]
    }

    out <- paste("#", out)                                # Turn into comment block
    out[length(out)] <- paste0(out[length(out)], "\n\n")  # Add blank lines after insertion

    rstudioapi::insertText(out)
}
