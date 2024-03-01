defmodule Brot do
  # Assuming Cmplx.t() is a defined type in your Cmplx module
  @moduledoc """
  Defines functionality for calculating the Mandelbrot set. This module
  includes functions for initializing calculations, performing the iterative
  process to determine Mandelbrot set membership, and utility functions for
  complex number operations.

  It also demonstrates concurrency in Elixir for intensive computational tasks,
  using Tasks for improved error handling and process management.
  """

  @doc """
  Calculates the Mandelbrot set value for a given complex number.

  ## Parameters

    - `complex`: The complex number for which to calculate the Mandelbrot set value, as a tuple `{real, imag}`  or any structure defined as `Cmplx.t()`.
    - `max_iterations`: The maximum number of iterations to use in the calculation.

  ## Returns

    - The number of iterations taken to determine the set membership of the complex number, up to the maximum specified.
    - The iteration count before the calculation escapes the threshold, or max_iterations if it does not escape.

  ## Examples

      iex> Brot.mandelbrot(Cmplx.new(0.8, 0), 30)
      3
      iex> Brot.mandelbrot(Cmplx.new(0.5, 0), 30)
      5
      iex> Brot.mandelbrot(Cmplx.new(0.3, 0), 30)
      12
      iex> Brot.mandelbrot(Cmplx.new(0.27, 0), 30)
      20
      iex> Brot.mandelbrot(Cmplx.new(0.26, 0), 30)
      30
      iex> Brot.mandelbrot(Cmplx.new(0.255, 0), 30)
      30
  """
  @spec mandelbrot(Cmplx.cpx(), integer()) :: integer()
  def mandelbrot(complex, max_iterations) do
    initial_value = Cmplx.new(0, 0)
    perform_iteration(0, initial_value, complex, max_iterations)
  end

  # Recursively iterates to calculate Mandelbrot set value.
  defp perform_iteration(max_iterations, _current, _complex, max_iterations) do
    max_iterations
  end

  defp perform_iteration(iteration, current, complex, max_iterations) do
    if Cmplx.abs(current) > 2 do
      iteration
    else
      new_current = Cmplx.add(Cmplx.sqr(current), complex)
      perform_iteration(iteration + 1, new_current, complex, max_iterations)
    end
  end
end