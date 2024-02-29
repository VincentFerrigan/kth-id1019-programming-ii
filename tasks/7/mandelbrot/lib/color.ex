defmodule Color do
  @moduledoc """
  A module for converting numerical iteration counts into color values.
  This module provides functions to map the results of the Mandelbrot set
  calculations to color for visualization.
  """

  @doc """
  Converts a given iteration count to an RGB color.

  ## Parameters

    - `d`: The iteration count.
    - `max`: The maximum iterations used in the Mandelbrot calculation.

  ## Returns

    - An RGB tuple representing the color.

  ## Examples

      iex> Color.convert(25, 100)
      {:rgb, 255, 0, 0}
  """
  @spec convert(non_neg_integer(), non_neg_integer()) :: {:rgb, integer(), integer(), integer()}
  def convert(d, max) do
#    red(d, max)
    convert(d, max, :red)
  end

  @doc """
  Converts a given iteration count to an RGB color based on the selected color scheme.

  ## Parameters

    - `d`: The iteration count.
    - `max`: The maximum iterations used in the calculation.
    - `color_scheme`: The color scheme to use for conversion.

  ## Returns

    - An RGB tuple representing the color.
  """
  @spec convert(non_neg_integer(), non_neg_integer(), atom()) :: {:rgb, integer(), integer(), integer()}
  def convert(d, max, color_scheme) do
    case color_scheme do
      :red -> red(d, max)
      :blue -> blue(d, max)
      :green -> green(d, max)
      _ -> {:rgb, 0, 0, 0} # Default color if an unknown scheme is provided
    end
  end

  # Maps an iteration count to a red gradient.
  @spec red(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  def red(d, max) do
    f = d / max
    a = f * 4
    x = trunc(a)
    y = trunc(255 * (a - x))

    case x do
      0 -> {:rgb, y, 0, 0}
      1 -> {:rgb, 255, y, 0}
      2 -> {:rgb, 255 - y, 255, 0}
      3 -> {:rgb, 0, 255, y}
      4 -> {:rgb, 0, 255 - y, 255}
    end
  end

  # Maps an iteration count to a blue gradient.
  @spec blue(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  def blue(d, max) do
    f = d / max
    a = f * 4
    x = trunc(a)
    y = trunc(255 * (a - x))

    case x do
      0 -> {:rgb, 0, 0, y}
      1 -> {:rgb, 0, y, 255}
      2 -> {:rgb, 0, 255, 255 - y}
      3 -> {:rgb, y, 255, 0}
      4 -> {:rgb, 255, 255 - y, 0}
    end
  end

  # Maps an iteration count to a green gradient.
  @spec green(integer(), integer()) :: {:rgb, integer(), integer(), integer()}
  def green(d, max) do
    f = d / max
    a = f * 4
    x = trunc(a)
    y = trunc(255 * (a - x))

    case x do
      0 -> {:rgb, 0, y, 0}
      1 -> {:rgb, y, 255, y}
      2 -> {:rgb, 255 - y, 255, 255 - y}
      3 -> {:rgb, 0, 255 - y, 0}
      4 -> {:rgb, 0, y, 0}
    end
  end

  # Add more color functions as needed.
end