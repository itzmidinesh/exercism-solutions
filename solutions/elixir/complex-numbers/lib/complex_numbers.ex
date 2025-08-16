defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {number, number}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: number
  def real({real, _imaginary}), do: real

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: number
  def imaginary({_real, imaginary}), do: imaginary

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | number, b :: complex | number) :: complex
  def mul({a_r, a_i}, {b_r, b_i}), do: {a_r * b_r - a_i * b_i, a_i * b_r + a_r * b_i}
  def mul({a_r, a_i}, b) when is_number(b), do: {a_r * b, a_i * b}
  def mul(a, {b_r, b_i}) when is_number(a), do: {a * b_r, a * b_i}

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | number, b :: complex | number) :: complex
  def add({a_r, a_i}, {b_r, b_i}), do: {a_r + b_r, a_i + b_i}
  def add({a_r, a_i}, b) when is_number(b), do: {a_r + b, a_i}
  def add(a, {b_r, b_i}) when is_number(a), do: {a + b_r, b_i}

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | number, b :: complex | number) :: complex
  def sub({a_r, a_i}, {b_r, b_i}), do: {a_r - b_r, a_i - b_i}
  def sub({a_r, a_i}, b) when is_number(b), do: {a_r - b, a_i}
  def sub(a, {b_r, b_i}) when is_number(a), do: {a - b_r, -b_i}

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | number, b :: complex | number) :: complex
  def div({a_r, a_i}, {b_r, b_i} = b) do
    denominator(b)
    |> then(&{(a_r * b_r + a_i * b_i) / &1, (a_i * b_r - a_r * b_i) / &1})
  end

  def div(a, {b_r, b_i} = b) when is_number(a) do
    denominator(b)
    |> then(&{a * b_r / &1, -a * b_i / &1})
  end

  def div({a_r, a_i}, b) when is_number(b), do: {a_r / b, a_i / b}

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: number
  def abs({real, imaginary}), do: :math.sqrt(real * real + imaginary * imaginary)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({real, imaginary}), do: {real, -imaginary}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({real, imaginary}) do
    :math.exp(real)
    |> then(&{&1 * :math.cos(imaginary), &1 * :math.sin(imaginary)})
  end

  defp denominator({r, i}), do: r * r + i * i
end
