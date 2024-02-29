defmodule Cmplx do
  @moduledoc """
  Provides functionalities for creating and operating on complex numbers.
  Complex numbers are represented as tuples tagged with `:cpx`, followed by their real and imaginary parts.
  """

  @doc """
  Creates a new complex number.

  ## Parameters
  - `real`: The real part of the complex number.
  - `imag`: The imaginary part of the complex number.

  ## Examples
      iex> Cmplx.new(1, 2)
      {:cpx, 1, 2}
  """
  @spec new(float, float) :: {:cpx, float, float}
  def new(real, imag) do
    {:cpx, real, imag}
  end

  @doc """
  Adds two complex numbers.

  ## Examples
      iex> Cmplx.add({:cpx, 1, 2}, {:cpx, 3, 4})
      {:cpx, 4, 6}
  """
  @spec add({:cpx, float, float}, {:cpx, float, float}) :: {:cpx, float, float}
  def add({:cpx, real1, imag1}, {:cpx, real2, imag2}) do
    new(real1 + real2, imag1 + imag2)
  end

  @doc """
  Squares a complex number.

  ## Examples
      iex> Cmplx.sqr({:cpx, 2, 3})
      {:cpx, -5, 12}
  """
  @spec sqr({:cpx, float, float}) :: {:cpx, float, float}
  def sqr({:cpx, real, imag}) do
    new(real * real - imag * imag, 2 * real * imag)
  end

  @doc """
  Calculates the absolute value (magnitude) of a complex number.

  ## Examples
      iex> Cmplx.abs({:cpx, 3, 4})
      5.0
  """
  @spec abs({:cpx, float, float}) :: float
  def abs({:cpx, real, imag}) do
    :math.sqrt(real * real + imag * imag)
  end
end