defmodule MandelbrotGenerator do
  @moduledoc """
  Provides functionality for generating the Mandelbrot set.
  This module calculates the Mandelbrot set for a given viewport
  and maps the calculation results to colors based on a specified color scheme.
  """

  @doc """
  Generates the Mandelbrot set for a specified viewport and resolution, applying a color scheme.

  ## Parameters

    - `width`: The width of the image in pixels.
    - `height`: The height of the image in pixels.
    - `x_center`: The x-coordinate of the viewport's center.
    - `y_center`: The y-coordinate of the viewport's center.
    - `scale`: The scale factor determining the zoom level of the viewport.
    - `max_iterations`: The maximum number of iterations to determine set membership.
    - `color_scheme`: The color scheme for coloring points outside the set.

  ## Returns

    - A 2D list (rows of pixels) where each element is an RGB tuple representing a pixel's color.

  ## Examples

      #iex> MandelbrotGenerator.mandelbrot(800, 600, -0.5, 0.0, 0.005, 100, :red)
      #[[{:rgb, 0, 0, 0}, ..., ...], ...]
  """
  @spec mandelbrot(integer(), integer(), number(), number(), number(), integer(), atom()) ::
          list(list({:rgb, integer(), integer(), integer()}))
  def mandelbrot(width, height, x_center, y_center, scale, max_iterations, color_scheme \\ :red) do
    # Translates pixel positions to complex numbers
    complex_translator = fn(pixel_x, pixel_y) ->
      Cmplx.new(x_center + scale * (pixel_x - 1), y_center - scale * (pixel_y - 1))
    end

    # Generate a task for each row to calculate in parallel
    tasks = for row_num <- 1..height do
      Task.async(fn -> process_row(width, row_num, complex_translator, max_iterations, color_scheme) end)
    end

    # Wait for all tasks to complete and collect the rows of RGB values
    Enum.map(tasks, &Task.await(&1, 30000))
    |> Enum.reverse()
  end

  # Processes a single row of pixels, calculating the color for each pixel based on Mandelbrot set membership
  defp process_row(width, row_num, complex_translator, max_iterations, color_scheme) do
    for col_num <- 1..width do
      # Translate pixel position to a complex number
      complex = complex_translator.(col_num, row_num)

      # Calculate Mandelbrot set membership and get iteration count
      iteration_count = Brot.mandelbrot(complex, max_iterations)

      # Convert iteration count to an RGB color value based on the chosen color scheme
      Color.convert(iteration_count, max_iterations, color_scheme)
    end
  end
end

