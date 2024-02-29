defmodule MandelbrotGenerator do
  @moduledoc """
  Provides functionality for generating the Mandelbrot set.
  This module calculates the Mandelbrot set for a given viewport
  and maps the calculation results to colours.
  """

  @doc """
  Generates the Mandelbrot set for a specified viewport and resolution.

  ## Parameters

    - `width`: The width of the viewport in pixels.
    - `height`: The height of the viewport in pixels.
    - `x`: The x-coordinate of the viewport's center.
    - `y`: The y-coordinate of the viewport's center.
    - `k`: The scale factor for the viewport.
    - `depth`: The maximum number of iterations per point.
    - `color_scheme`: The color scheme to use for conversion.

  ## Returns

    - A list of rows, each containing RGB tuples for each pixel.

  ## Examples

      #iex> MandelbrotGenerator.mandelbrot(800, 600, -0.5, 0.0, 0.005, 100)
      #[{:rgb, 0, 0, 0}, ..., ...]  -->
  """
  @spec mandelbrot(integer, integer, float, float, float, integer, atom()) ::
          list(list({:rgb, integer, integer, integer}))
  def mandelbrot(width, height, x, y, k, depth, color_scheme \\ :red) do
    # Translates pixel positions to complex numbers
    trans = fn(w, h) -> Cmplx.new(x + k * (w - 1), y - k * (h - 1)) end

    # Initialize an asynchronous task for each row
    tasks = for h <- 1..height, do: Task.async(fn -> process_row(width, h, trans, depth, color_scheme) end)

    # Wait for all tasks to complete and collect results
#    rows = tasks |> Enum.map(&Task.await(&1)) |> Enum.reverse()
    rows = tasks |> Enum.map(&Task.await(&1, 30000)) |> Enum.reverse()

    # Return the processed rows
    rows
  end

  defp process_row(width, height, trans, depth, color_scheme) do
    for w <- 1..width do
      complex = trans.(w, height)
      calculation = Brot.mandelbrot(complex, depth) # Assuming Brot.mandelbrot/2 is adjusted for concurrency
      Color.convert(calculation, depth, color_scheme)
    end
  end
end
