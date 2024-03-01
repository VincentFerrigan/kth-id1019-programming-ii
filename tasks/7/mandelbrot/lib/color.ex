defmodule Color do
  @moduledoc """
  A module for converting numerical iteration counts into color values.
  This module provides functions to map the results of the Mandelbrot set
  calculations to color for visualization.
  """

  @doc """
  Converts a given iteration count to an RGB color based on the selected color scheme.

  ## Parameters

    - `depth`: The depth or iteration count.
    - `max`: The maximum iterations used in the calculation.
    - `color_scheme`: The color scheme to use for conversion.

  ## Returns

    - An RGB tuple representing the color.
  """
  @spec convert(non_neg_integer(), non_neg_integer(), atom())
        :: {:rgb, integer(), integer(), integer()}
  def convert(depth, max, color_scheme) do
    case color_scheme do
      :red -> red(depth, max)
      :blue -> blue(depth, max)
      :green -> green(depth, max)
      _ -> {:rgb, 0, 0, 0}
    end
  end

  # Maps an iteration count to a red gradient.
  @spec red(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  defp red(iteration_count, max_iterations) do
    # Calculate the fraction of the maximum iterations reached
    fraction_of_max = iteration_count / max_iterations
    # Scale the fraction to a range that maps to our color transitions
    scaled_fraction = fraction_of_max * 4
    # Determine the major color phase based on the scaled fraction
    color_phase = trunc(scaled_fraction)
    # Calculate the intensity within the current color phase (0-255)
    intensity = trunc(255 * (scaled_fraction - color_phase))

    case color_phase do
      # Transition from black to red
      0 -> {:rgb, intensity, 0, 0}
      # Transition from red to yellow (increasing green)
      1 -> {:rgb, 255, intensity, 0}
      # Transition from yellow to green (decreasing red)
      2 -> {:rgb, 255 - intensity, 255, 0}
      # Transition from green to cyan (increasing blue)
      3 -> {:rgb, 0, 255, intensity}
      # Transition from cyan to blue (decreasing green)
      4 -> {:rgb, 0, 255 - intensity, 255}
    end
  end

  # Maps an iteration count to a blue gradient.
  @spec blue(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  defp blue(iteration_count, max_iterations) do
    fraction_of_max = iteration_count / max_iterations
    scaled_fraction = fraction_of_max * 4
    color_phase = trunc(scaled_fraction)
    intensity = trunc(255 * (scaled_fraction - color_phase))

    case color_phase do
      0 -> {:rgb, 0, 0, intensity}
      1 -> {:rgb, 0, intensity, 255}
      2 -> {:rgb, 0, 255, 255 - intensity}
      3 -> {:rgb, intensity, 255, 0}
      4 -> {:rgb, 255, 255 - intensity, 0}
    end
  end

  # Maps an iteration count to a green gradient.
  @spec green(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  defp green(iteration_count, max_iterations) do
    fraction_of_max = iteration_count / max_iterations
    scaled_fraction = fraction_of_max * 4
    color_phase = trunc(scaled_fraction)
    intensity = trunc(255 * (scaled_fraction - color_phase))

    case color_phase do
      0 -> {:rgb, 0, intensity, 0}
      1 -> {:rgb, intensity, 255, intensity}
      2 -> {:rgb, 255 - intensity, 255, 255 - intensity}
      3 -> {:rgb, 0, 255 - intensity, 0}
      4 -> {:rgb, 0, intensity, 0}
    end
  end

  # ...more color functions added
  # Add more color functions as needed.
end