defmodule Cmplx do
  @moduledoc """
  Provides functionalities for creating and operating on complex numbers.
  Complex numbers are represented as tuples tagged with `:cpx`, followed by their real and imaginary parts.
  """

  @typedoc """
  Defines a complex number as a tagged tuple.

  The `:cpx` tag is used to explicitly identify the tuple as representing a complex number, followed by two numbers representing the real and imaginary parts of the complex number, respectively.
  """
  @type cpx() :: {:cpx, number(), number()}

  @doc """
  Creates a new complex number.

  ## Parameters
  - `real`: The real part of the complex number.
  - `imag`: The imaginary part of the complex number.

  ## Examples
      iex> Cmplx.new(1, 2)
      {:cpx, 1, 2}
  """
  @spec new(number(), number()) :: cpx()
  def new(real, imag), do: {:cpx, real, imag}

  @doc """
  Adds two complex numbers.

  ## Examples
      iex> Cmplx.add({:cpx, 1, 2}, {:cpx, 3, 4})
      {:cpx, 4, 6}
  """
  @spec add(cpx(), cpx()) :: cpx()
  def add({:cpx, real1, imag1}, {:cpx, real2, imag2}) do
    new(real1 + real2, imag1 + imag2)
  end

  @doc """
  Squares a complex number.

  ## Examples
      iex> Cmplx.sqr({:cpx, 2, 3})
      {:cpx, -5, 12}
  """
  @spec sqr(cpx()) :: cpx()
  def sqr({:cpx, real, imag}) do
    new(real * real - imag * imag, 2 * real * imag)
  end

  @doc """
  Calculates the absolute value (magnitude) of a complex number.

  ## Examples
      iex> Cmplx.abs({:cpx, 3, 4})
      5.0
  """
  @spec abs(cpx()) :: number()
  def abs({:cpx, real, imag}), do: :math.sqrt(real * real + imag * imag)
end