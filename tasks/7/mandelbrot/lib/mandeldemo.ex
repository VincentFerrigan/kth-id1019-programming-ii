defmodule MandelDemo do
  @moduledoc """
  A demo module for generating and saving images of the Mandelbrot set with customizable parameters and color mappings.
  """

  @doc """
  Generates and saves an image of the Mandelbrot set based on user-specified parameters and color mapping.
  """
  def run_demo do
    IO.puts "Enter the x-coordinate of the center:"
    {x0, _} = IO.gets("> ") |> String.trim() |> Float.parse()

    IO.puts "Enter the y-coordinate of the center:"
    {y0, _} = IO.gets("> ") |> String.trim() |> Float.parse()

    IO.puts "Enter the zoom level (e.g., 0.008 for a close-up view):"
    {xn, _} = IO.gets("> ") |> String.trim() |> Float.parse()

    IO.puts "Choose resolution: 1) Small (720x480) 2) Large (2560x1440)"
    resolution_choice = IO.gets("> ") |> String.trim() |> String.to_integer()

    IO.puts "Choose a color mapping: 1) Red 2) Blue 3) Green"
    color_choice = IO.gets("> ") |> String.trim() |> String.to_integer()

    generate_image(x0, y0, xn, resolution_choice, color_choice)
  end

  defp generate_image(x0, y0, xn, resolution_choice, color_choice) do
    {width, height, size} =
      case resolution_choice do
        1 -> {720, 480, :small}
        _ -> {2560, 1440, :large}
      end

    color_scheme =
      case color_choice do
        1 -> :red
        2 -> :blue
        3 -> :green
        _ -> :red
      end

    depth = 256 * 3
    k = (xn - x0) / width
    image = MandelbrotGenerator.mandelbrot(width, height, x0, y0, k, depth, color_scheme)
    file_name = "mb_#{Atom.to_string(size)}_#{Atom.to_string(color_scheme)}_x#{x0}_y#{y0}_xn#{xn}.ppm"

    PPM.write(file_name, image)
    IO.puts("#{file_name} has been saved.")
  end
end

